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

@synthesize fetchedResultsController, managedObjectContext, curScores, table, filterLabel, segmentedControl;
@synthesize	notesView, notesTitleLabel, notesTextView;
@synthesize wodNameFilter, wodDateFilter, wodFilter;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.notesView = [[[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, 300)] 
					 autorelease];
		[self.notesView setBackgroundColor:[UIColor blackColor]];
		[self.notesView setAlpha:.87];

		// Title
		notesTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
		notesTitleLabel.font = [UIFont boldSystemFontOfSize:17];
		notesTitleLabel.textAlignment = UITextAlignmentCenter;
		notesTitleLabel.textColor = [UIColor whiteColor];
		notesTitleLabel.backgroundColor = [UIColor clearColor];
		[self.notesView addSubview:notesTitleLabel];
		
		// Message
		notesTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 300, 270)];
		notesTextView.font = [UIFont systemFontOfSize:15];
		notesTextView.textAlignment = UITextAlignmentLeft;
		notesTextView.textColor = [UIColor whiteColor];
		notesTextView.backgroundColor = [UIColor clearColor];
		notesTextView.editable = NO;
		[self.notesView addSubview:notesTextView];

		UITapGestureRecognizer *touch = 
		[[UITapGestureRecognizer alloc] initWithTarget:self 
												action:@selector(notesViewTouched:)];
		[self.notesView addGestureRecognizer:touch];
		[touch release];
		
		//[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
		
		// Set the title of the nav bar to WOD List when WODListViewController
		// is on top of the stack
		[self setTitle:@"Scores"];
	}

	
	return self;
}



- (void)viewDidLoad {
	
    [super viewDidLoad];
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
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



- (void)notesViewTouched:(UITapGestureRecognizer *)recognizer {
	
	CGRect frame = self.notesView.frame;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.5];
	
	[self.view addSubview:notesView];
	frame.origin.y = 480;
	self.notesView.frame = frame;
	
	[UIView commitAnimations];
	
	table.allowsSelection = YES;
}



- (IBAction)exportPressed:(id)sender {
	
	[self exportAllData];
	
}



- (IBAction)toggleSort	{

	selectedUnit = [segmentedControl selectedSegmentIndex];
	NSSortDescriptor *nameDescriptor, *timeDescriptor, *roundDescriptor, *repDescriptor;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"score" inManagedObjectContext:managedObjectContext];
	NSString	*key;
	NSArray *sortDescriptors;
	
	if (selectedUnit == DATE_INDEX) {
		
		nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
		key = @"date";
		sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
		[nameDescriptor release];
		
	} else {
		
		nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wod.name" ascending:YES];
		timeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
		roundDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rounds" ascending:YES];
		repDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reps" ascending:YES];
		
		key = @"wod.name";
		sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, timeDescriptor, roundDescriptor, repDescriptor, nil];
		[timeDescriptor release];
		[roundDescriptor release];
		[repDescriptor release];
		[nameDescriptor release];

	}
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setEntity:entity];
	
	if ([self wodFilter]) {
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"wod==%@", [self wodFilter]]];
	} else if([self wodDateFilter]) {
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date==%@", [self wodDateFilter]]];
	}
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"time" cacheName:nil];
	[self setFetchedResultsController:aFetchedResultsController];
	[[self fetchedResultsController] setDelegate:self];
	
	// Memory management.
	[aFetchedResultsController release];	
	[sortDescriptors release];
	[fetchRequest release];

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

    return [[fetchedResultsController sections] count];
	
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];

	return [sectionInfo numberOfObjects];
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath	{
	
	table.allowsSelection = NO;
	
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateFormat:@"MM/dd/yyyy"];
	SCORE	*score = [fetchedResultsController objectAtIndexPath:indexPath];

	NSString	*date = [format stringFromDate:[score date]];
	NSString	*wodName = [[score wod] name];
	notesTextView.text = [score notes];
	notesTitleLabel.text = [NSString stringWithFormat:@"%@ - %@", date, wodName];
	
	//  UIView *view = self.view;
	CGRect frame = self.notesView.frame;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.5];
	
	[self.view addSubview:notesView];
	frame.origin.y = 116;
	self.notesView.frame = frame;
	
	[UIView commitAnimations];

	
	/*NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy"];
	NSString	*date = [format stringFromDate:[score date]];
	NSString	*wodName = [[score wod] name];
	
	[controller setTitleName:[NSString stringWithFormat:@"%@ - %@", date, wodName]];
	[controller setEditType:EDIT_TYPE_TEXTBOX];
	[controller setDefaultText:[score notes]];
	[controller setPopToRoot:NO];
	[[self navigationController] pushViewController:controller animated:YES];		
	
	[controller release];
	[format release];*/
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *ScoreCellIdentifier = @"ScoreCellIdentifier";
    
    ScoreTableViewCell *scoreCell = (ScoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScoreCellIdentifier];
    if (scoreCell == nil) {
        scoreCell = [[[ScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ScoreCellIdentifier] autorelease];
		[scoreCell setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    
	[self configureCell:scoreCell atIndexPath:indexPath];
    
    return scoreCell;
	
}



- (void)configureCell:(ScoreTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	SCORE *newscore = (SCORE *)[fetchedResultsController objectAtIndexPath:indexPath];
    cell.score = newscore;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	[table setEditing:editing animated:animated];
	
	[[self navigationItem] setHidesBackButton:editing animated:YES];
	
	if (editing) {
		//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createWOD)];
		//[self.navigationItem setLeftBarButtonItem:addButton animated:animated];
		//[addButton release];
	} else {
	
		[[self navigationItem] setLeftBarButtonItem:nil animated:NO];
		
	}	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		NSLog(@"%@",[fetchedResultsController fetchedObjects]);
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }   
}


#pragma mark -
#pragma mark Data Exporting



- (void)exportAllData {
	
	// Get the current date/time and format it
	NSDateFormatter *timestampFormat = [[[NSDateFormatter alloc] init] autorelease];
	[timestampFormat setDateFormat:@"yyyyMMddHHmmss"];
	NSString	*timestamp = [timestampFormat stringFromDate:[NSDate date]];

	// Generate the path/filename
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"mywodlog-%@.csv", timestamp];
	NSString *file = [docDir stringByAppendingPathComponent:filename];
	
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateFormat:@"MM-dd-yyyy HH:mm"];
	
	//CHCSVWriter *csvWriter = [[[CHCSVWriter alloc] initWithCSVFile:filename atomic:YES] autorelease];
	CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initWithCSVFile:file atomic:YES];
	
	// Write the header line
	[csvWriter writeLineOfFields:@"Date",@"WOD",@"WOD Type",@"Score",@"Score Type",@"Rx",nil];
	
	for (id obj in [[self fetchedResultsController] fetchedObjects]) {
		
		SCORE	*score = (SCORE*)obj;
		WOD		*wod = [score wod];
		
		// Generate 'Rx' field data
		NSString *RxString = nil;
		
		if ([[score Rx] boolValue]) {
			RxString = @"YES";
		} else {
			RxString = @"NO";
		}

		
		// Generate 'Score' field data
		NSString *scoreString = nil;
		
		if ([[score time] intValue] > 0) {
			scoreString = [[score time] stringValue];
		} else if ([[score rounds] intValue] > 0) {
			scoreString = [[score rounds] stringValue];
		} else if ([[score reps] intValue] > 0) {
			scoreString = [[score reps] stringValue];
		} else if ([[score completed] boolValue]) {
			scoreString = @"1";
		} else {
			scoreString = @"0";
		}
		
		// Write the fields
		[csvWriter writeField:[format stringFromDate:[score date]]];
		[csvWriter writeField:[[wod name] capitalizedString]];
		[csvWriter writeField:[WOD wodTypeToString:[[wod type] intValue]]];
		[csvWriter writeField:scoreString];
		[csvWriter writeField:[WOD wodScoreTypeToString:[[wod score_type] intValue]]];
		[csvWriter writeField:RxString];
		[csvWriter writeLine];
		
	}
	
	[csvWriter release];
	
	
	// Send the CSV file via e-mail
	NSData *attachment = [NSData dataWithContentsOfFile:file];
	
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	[controller setMailComposeDelegate:self];
	[controller setSubject:[NSString stringWithFormat:@"My WOD Log data as of: %@", [format stringFromDate:[NSDate date]]]];
	[controller setMessageBody:@"The data is attached" isHTML:NO];
	[controller addAttachmentData:attachment mimeType:@"text/csv" fileName:filename];
	if (controller) {
		[self presentModalViewController:controller animated:YES];
	}
	[controller release];
	
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {

	if (result == MFMailComposeResultSent) {
	} else {
	}

	[self dismissModalViewControllerAnimated:YES];
	
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
	
	if ([self wodFilter] != nil) {

		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"score" inManagedObjectContext:managedObjectContext];

		[fetchRequest setEntity:entity];

		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"wod==%@", [self wodFilter]]];

		// Create the sort descriptors array.
		NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];

			
		// Create and initialize the fetch results controller.
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"time" cacheName:nil];
		[self setFetchedResultsController:aFetchedResultsController];
		[[self fetchedResultsController] setDelegate:self];
		
		// Memory management.
		[aFetchedResultsController release];
		[fetchRequest release];
		[nameDescriptor release];
		
	} else if ([self wodDateFilter] != nil) {
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"score" inManagedObjectContext:managedObjectContext];
		
		[fetchRequest setEntity:entity];
		
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date==%@", [self wodDateFilter]]];
		
		// Create the sort descriptors array.
		NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		
		// Create and initialize the fetch results controller.
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"time" cacheName:nil];
		[self setFetchedResultsController:aFetchedResultsController];
		[[self fetchedResultsController] setDelegate:self];
		
		// Memory management.
		[aFetchedResultsController release];
		[fetchRequest release];
		[nameDescriptor release];
		
	} else {
		
		// Create and configure a fetch request with the 'score' entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"score" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Create the sort descriptors array.
		NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		
		// Create and initialize the fetch results controller.
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"time" cacheName:nil];
		[self setFetchedResultsController:aFetchedResultsController];
		[[self fetchedResultsController] setDelegate:self];
		
		// Memory management.
		[aFetchedResultsController release];
		[fetchRequest release];
		[nameDescriptor release];
		
	}
    
	
	
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
	NSLog(@"Updating table");
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			NSLog(@"Deleting rows");
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
	self.fetchedResultsController = nil;
	[fetchedResultsController release];
    [super dealloc];
}


@end
