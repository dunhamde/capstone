//
//  ViewScoresViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewScoresViewController.h"
#import "MyWODLogAppDelegate.h"
#import "SCORE.h"
#import "ScoreTableViewCell.h"

@implementation ViewScoresViewController

@synthesize  fetchedResultsController, managedObjectContext, curScores,table, filterLabel, segmentedControl;

- (id)init {
	// Call the superclass's designated initializer
	//[super initWithStyle:UITableViewStyleGrouped];
	
	toolbar = [[UIToolbar alloc] init];
	toolbar.barStyle = UIBarStyleDefault;
	[toolbar sizeToFit];
	

	
	//[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	// Set the title of the nav bar to WOD List when WODListViewController
	// is on top of the stack
	[self setTitle:@"Scores"];
//	[[self navigationController] toolbarHidden:NO];

//	self.navigationController.toolbarHidden = YES;
	
	return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	filterLabel.backgroundColor = [UIColor clearColor];
	filterLabel.font = [UIFont boldSystemFontOfSize: 15.0f];
	filterLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	filterLabel.textAlignment = UITextAlignmentCenter;
	
	
	if (managedObjectContext == nil) 
        managedObjectContext = [(MyWODLogAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
}

- (IBAction)toggleSort	{
	
	NSLog(@"TOGGLE");
	
	selectedUnit = [segmentedControl selectedSegmentIndex];
	NSSortDescriptor *nameDescriptor;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"score" inManagedObjectContext:managedObjectContext];
	NSString	*key;
	if (selectedUnit == DATE_INDEX) {
		nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
		key = @"date";
	} else {
		nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wod.name" ascending:YES];
		key = @"wod.name";
	}
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setEntity:entity];
	[fetchedResultsController initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:key cacheName:@"Root"];	
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	[table reloadData];
}

#pragma mark -
#pragma mark Table view data source methods

/*
 The data source methods are handled primarily by the fetch results controller
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog( @"SCORES NUM OF SECTIONS IN TABLE = %d", [[fetchedResultsController sections] count] );
	NSLog(@"fetched results: %@", fetchedResultsController);

    return [[fetchedResultsController sections] count];
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	NSLog( @"SCORES NUM OF ROWS IN SECTION = %d", [sectionInfo numberOfObjects] );
	return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"CELL");
    // Dequeue or if necessary create a ScoreTableViewCell, then set its recipe to the recipe for the current row.
    static NSString *ScoreCellIdentifier = @"ScoreCellIdentifier";
    
    ScoreTableViewCell *scoreCell = (ScoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScoreCellIdentifier];
    if (scoreCell == nil) {
        scoreCell = [[[ScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ScoreCellIdentifier] autorelease];
		//scoreCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	[self configureCell:scoreCell atIndexPath:indexPath];
    
    return scoreCell;
}


- (void)configureCell:(ScoreTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	SCORE *newscore = (SCORE *)[fetchedResultsController objectAtIndexPath:indexPath];
    cell.score = newscore;
}




#pragma mark -
#pragma mark Selection and moving

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
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
    
	// Create and configure a fetch request with the 'score' entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"score" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"time" cacheName:@"Root"];
	[self setFetchedResultsController:aFetchedResultsController];
	//	self.fetchedResultsController = aFetchedResultsController;
	[[self fetchedResultsController] setDelegate:self];
	//	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	
	return fetchedResultsController;
}    



/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[[self table] beginUpdates];
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = [self table];
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}



- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[[self table] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[[self table] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[[self table] endUpdates];
}


#pragma mark -
#pragma mark Memory


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
