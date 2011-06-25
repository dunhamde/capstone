//
//  ProgressChartViewController.m
//  MyWODLog
//
//  Created by Derek Dunham on 5/31/11.
//  Copyright 2011 student. All rights reserved.
//

#import "ProgressChartViewController.h"


@implementation ProgressChartViewController

@synthesize plotData, fetchedResultsController, managedObjectContext, wod;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

-(void)viewDidLoad 
{
	// Fetch score data
	if (managedObjectContext == nil) 
        managedObjectContext = [(MyWODLogAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	NSArray *scores = [fetchedResultsController fetchedObjects];
	
	// If you make sure your dates are calculated at noon, you shouldn't have to 
    // worry about daylight savings. If you use midnight, you will have to adjust
    // for daylight savings time.
    NSDate *refDate = [[scores lastObject] date];
    NSTimeInterval oneDay = 24 * 60 * 60;
	
    // Create graph from theme
    graph = [[CPXYGraph alloc] initWithFrame:CGRectZero];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
    [graph applyTheme:theme];
	CPGraphHostingView *hostingView = (CPGraphHostingView *)self.view;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = graph;
	
	graph.paddingLeft = 5.0;
	graph.paddingTop = 5.0;
	graph.paddingRight = 5.0;
	graph.paddingBottom = 5.0;
    
    // Setup scatter plot space
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow = 0.0f;
	
	NSDate *earliestScore = [[scores lastObject] date];
	NSDate *latestScore = [[scores objectAtIndex:0] date];
	float xRangeLength = [latestScore timeIntervalSinceDate:earliestScore];
	
	float maxScore = 0;
	for (int i = 0; i < [scores count]; i++) {
		if ([[[scores objectAtIndex:i] time] floatValue] > maxScore) {
			maxScore = [[[scores objectAtIndex:i] time] floatValue];
		}
	}
	if ([[wod score_type] intValue] == WOD_SCORE_TYPE_TIME) {
		for (int i = 0; i < [scores count]; i++) {
			if ([[[scores objectAtIndex:i] time] floatValue] > maxScore) {
				maxScore = [[[scores objectAtIndex:i] time] floatValue];
			}
		}
		maxScore = maxScore/60 + 1;
	}
	else if ([[wod score_type] intValue] == WOD_SCORE_TYPE_REPS) {
		for (int i = 0; i < [scores count]; i++) {
			if ([[[scores objectAtIndex:i] reps] floatValue] > maxScore) {
				maxScore = [[[scores objectAtIndex:i] reps] floatValue];
			}
		}
		maxScore = maxScore + 1;
	}
	else if ([[wod score_type] intValue] == WOD_SCORE_TYPE_RNDS) {
		for (int i = 0; i < [scores count]; i++) {
			if ([[[scores objectAtIndex:i] rounds] floatValue] > maxScore) {
				maxScore = [[[scores objectAtIndex:i] rounds] floatValue];
			}
		}
		maxScore = maxScore + 1;
	}
		

    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(xLow-oneDay) length:CPDecimalFromFloat(xRangeLength+oneDay*2)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-0.5) length:CPDecimalFromFloat(maxScore)];
	plotSpace.allowsUserInteraction = YES;

    // Axes
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
	x.labelingPolicy = CPAxisLabelingPolicyAutomatic;
    x.majorIntervalLength = CPDecimalFromFloat(oneDay);
    x.orthogonalCoordinateDecimal = CPDecimalFromString(@"0");
    x.minorTicksPerInterval = 0;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"MM/dd"];
    CPTimeFormatter *timeFormatter = [[[CPTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter = timeFormatter;
	x.title = @"Date";
	
    CPXYAxis *y = axisSet.yAxis;
	y.labelingPolicy = CPAxisLabelingPolicyAutomatic;
    y.majorIntervalLength = CPDecimalFromString(@"1.0");
    y.minorTicksPerInterval = 5;
    y.orthogonalCoordinateDecimal = CPDecimalFromFloat(oneDay);
	
	switch ([[wod score_type] intValue]) {
		case WOD_SCORE_TYPE_NONE:
			y.title = @"None";
			break;
		case WOD_SCORE_TYPE_TIME:
			y.title = @"Time";
			break;
		case WOD_SCORE_TYPE_REPS:
			y.title = @"Reps";
			break;
		case WOD_SCORE_TYPE_RNDS:
			y.title = @"Rounds";
			break;
		default:
			break;
	}	
	
    // Create a plot that uses the data source method
	CPScatterPlot *dataSourceLinePlot = [[[CPScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Date Plot";
	
	CPMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
	lineStyle.lineWidth = 3.f;
    lineStyle.lineColor = [CPColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.dataSource = self;
	
	// Put an area gradient under the plot above
    CPColor *areaColor = [CPColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPGradient *areaGradient = [CPGradient gradientWithBeginningColor:areaColor endingColor:[CPColor clearColor]];
    areaGradient.angle = -90.0f;
    CPFill *areaGradientFill = [CPFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = CPDecimalFromString(@"0.00");
	
    [graph addPlot:dataSourceLinePlot];
	
    // Add some data
	NSMutableArray *newData = [NSMutableArray array];
	NSUInteger i;
	for ( i = 0; i < [scores count] ; i++ ) {
		id y;
		NSTimeInterval x = [[[scores objectAtIndex:i] date] timeIntervalSinceDate:refDate];
		float minutes, seconds;
		switch ([[wod score_type] intValue]) {
			case WOD_SCORE_TYPE_NONE:
				break;
			case WOD_SCORE_TYPE_TIME:
				seconds = [[[scores objectAtIndex:i] time] floatValue];
				minutes = seconds / 60;
				y = [NSDecimalNumber numberWithFloat:minutes];
				break;
			case WOD_SCORE_TYPE_REPS:
				y = [NSDecimalNumber numberWithFloat:[[[scores objectAtIndex:i] reps] floatValue]];
				break;
			case WOD_SCORE_TYPE_RNDS:
				y = [NSDecimalNumber numberWithFloat:[[[scores objectAtIndex:i] rounds] floatValue]];
				break;
			default:
				break;
		}
		[newData addObject:
		 [NSDictionary dictionaryWithObjectsAndKeys:
		  [NSDecimalNumber numberWithFloat:x], [NSNumber numberWithInt:CPScatterPlotFieldX], 
		  y, [NSNumber numberWithInt:CPScatterPlotFieldY], 
		  nil]];
	}
	[self setPlotData:newData];


	[scores release];
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot
{    
	return [plotData count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = [[plotData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    return num;
}

#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
	// Do not use [self fetchedResultsController] or self.fetchedResultsController (stack overflow)
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }

		
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"score" inManagedObjectContext:managedObjectContext];
	
	[fetchRequest setEntity:entity];
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"wod==%@", [self wod]]];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"time" cacheName:nil];
	[self setFetchedResultsController:aFetchedResultsController];
	//[[self fetchedResultsController] setDelegate:self];
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	
	return fetchedResultsController;
}  


-(void)dealloc 
{
	[plotData release];
    [super dealloc];
}


@end
