//
//  ViewWODViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewWODViewController.h"
#import "MyWODLogAppDelegate.h"


@implementation ViewWODViewController

@synthesize wod, scoredByLabel, wodExerciseArray, table, logButton; // removed the list label in order to add the tabel
@synthesize showNumRounds, showRepRounds, showTimeLimit;
@synthesize wodName, wodNotes, wodType, wodTimeLimit, wodNumRounds, wodRepRounds, wodScoreType;
@synthesize logScoreViewController, managedObjectContext, fetchedResultsController;



- (id)init {	
	return self;
}



- (void)viewDidLoad {

	[self setLogButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(logScorePressed:)]];
	[[self logButton] setEnabled:YES];
	[[self navigationItem] setRightBarButtonItem:[self logButton]];
	[logButton release];
	
	if (managedObjectContext == nil) {
        managedObjectContext = [(MyWODLogAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
	}
	
}



- (void)setCurrentWOD:(WOD *)w {

	[self setWod:w];
	//[self setWodName:[[self wod] name]];
	//[self setWodType:[[[self wod] score_type] intValue]];
	//[self setWodNotes:[[self wod] notes]];
	
	if ([[w timelimit] intValue] > 0) {
		[self setShowTimeLimit:YES];
	}
	
	[self setTitle:[[wod name] capitalizedString]];

}



- (IBAction)logScorePressed:(id)sender {
	
	LogScoreViewController* logScore = [[LogScoreViewController alloc] init];
	
	[logScore setWod:[self wod]];
	[logScore setDelegate:self];
	[[self navigationController] pushViewController:logScore animated:YES];

	[logScore release];
}



#pragma mark -
#pragma mark Table View Controller stuff



// Customize the number of rows in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return VW_NUM_SECTIONS;
	
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    NSString *title = nil;
	
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case VW_SECTION_DETAILS:
            title = VW_SECTION_TITLE_DETAILS;
            break;
        case VW_SECTION_EXERCISES:
            title = VW_SECTION_TITLE_EXERCISES;
            break;
		case VW_SECTION_NOTES:
            title = VW_SECTION_TITLE_NOTES;
            break;
        default:
            break;
    }
	
    return title;
	
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger rows = 0;
	
	switch (section) {
        case VW_SECTION_DETAILS:
			rows = 2;
			if ([self showTimeLimit]) {
				rows++;
			}
			if ([self showNumRounds]) {
				rows++;
			} else if ([self showRepRounds]) {
				rows++;
			}
            break;
        case VW_SECTION_EXERCISES:
            rows = [[self wodExerciseArray] count];
            break;
        case VW_SECTION_NOTES:
            rows = 1;
            break;			
        default:
            break;
    }
	
    return rows;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ( [indexPath section] == VW_SECTION_DETAILS && [indexPath row] == 0 ) {
		
		static NSString *NameCellIdentifier = @"NameCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:NameCellIdentifier] autorelease];
			//[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
    }
	else if ( [indexPath section] == VW_SECTION_DETAILS && [indexPath row] == 1 ) {
		
		static NSString *TypeCellIdentifier = @"TypeCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			//[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == VW_SECTION_DETAILS && [indexPath row] == 2 && [[[self wod] type] intValue] == WOD_TYPE_RRFT ) {
	//else if ( [indexPath section] == VW_SECTION_DETAILS && [indexPath row] == 2 ) {
		
		static NSString *TypeCellIdentifier = @"RepRoundsCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			//[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == VW_SECTION_DETAILS && [indexPath row] == 2 &&
			 ([[[self wod] type] intValue] == WOD_TYPE_RFT || [[[self wod] type] intValue] == WOD_TYPE_EMOTM || [[[self wod] type] intValue] == WOD_TYPE_AMRAP) ) {
		
		static NSString *TypeCellIdentifier = @"TimeLimitCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			//[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == VW_SECTION_DETAILS &&
			 ([indexPath row] == 3 ||([indexPath row] == 2 && [[[self wod] type] intValue] == WOD_TYPE_RFMR)) ) {
		
		static NSString *TypeCellIdentifier = @"NumRoundsCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == VW_SECTION_EXERCISES && [indexPath row] < [[self wodExerciseArray] count] ) {
		
		static NSString *ExerciseCellIdentifier = @"ExerciseCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExerciseCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ExerciseCellIdentifier] autorelease];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == VW_SECTION_NOTES ) {
		
		static NSString *NotesCellIdentifier = @"NotesCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NotesCellIdentifier];
		
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NotesCellIdentifier] autorelease];
			//[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
			//[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
	}

	return nil;
}





- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	// Can't we do this by cell name instead of section/row numbers?
	// i.e.:  [cell reuseIdentifier]  << returns a string
	
	NSString *cellIdentifier = [cell reuseIdentifier];
	
	if( [cellIdentifier isEqualToString:@"NameCell"] ) {
		
		[[cell textLabel] setText:@"Name"];
		
		if ([[self wod] name] != nil) {
			[[cell detailTextLabel] setText:[[[self wod] name] capitalizedString]];
		} else {
			[[cell detailTextLabel] setText:@"<WOD NAME HERE>"];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"TypeCell"] ) {
		
		[[cell textLabel] setText:@"Type"];
		
		NSString *subText = nil;
		switch ([[[self wod] type] intValue]) {
			case WOD_TYPE_TIME:
				subText = WOD_TYPE_TEXT_TIME;
				break;
			case WOD_TYPE_RFT:
				subText = WOD_TYPE_TEXT_RFT;
				break;
			case WOD_TYPE_RRFT:
				subText = WOD_TYPE_TEXT_RRFT;
				break;
			case WOD_TYPE_RFMR:
				subText = WOD_TYPE_TEXT_RFMR;
				break;
			case WOD_TYPE_AMRAP:
				subText = WOD_TYPE_TEXT_AMRAP;
				break;
			case WOD_TYPE_EMOTM:
				subText = WOD_TYPE_TEXT_EMOTM;
				break;
			default:
				subText = WOD_TYPE_TEXT_UNKNOWN;
				break;
		}
		
		[[cell detailTextLabel] setText:subText];
		
	}
	else if( [cellIdentifier isEqualToString:@"ExerciseCell"] ) {
		
		if( [indexPath row] < [[self wodExerciseArray] count] ) {
			
			// Find the correct next eexercise
			NSEnumerator *enumer = [wodExerciseArray objectEnumerator];
			EEXERCISE *eexercise = nil;
			
			while ( (eexercise = (EEXERCISE*)[enumer nextObject]) ) {
					if ( [indexPath row] + 1 == [[eexercise order] intValue] ) {
						break;
					}
			}
			//eexercise = (EEXERCISE *)[wodExerciseArray objectAtIndex:[indexPath row]];
			
			
			NSString* exerciseText = nil;
			NSString *ename = nil;
			
			if ([eexercise name] != nil && [[eexercise name] length] > 0) {
				ename = [eexercise name];
			} else {
				ename = [[eexercise exercise] name];
			}
			
			if ([[eexercise quantity] intValue] > 0) {
				exerciseText = [[NSString alloc] initWithFormat:@"%@ %@",[[eexercise quantity] stringValue],ename];
			} else {
				exerciseText = ename;
			}
			
			
			[[cell textLabel] setText:[exerciseText capitalizedString]];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"NotesCell"] ) {
		
		if ([[self wod] notes] != nil && [[[self wod] notes] length] > 0) {
			[[cell textLabel] setText:[[self wod] notes]];
		} else {
			[[cell textLabel] setText:@"N/A"];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"NumRoundsCell"] ) {
		
		[[cell textLabel] setText:@"# Rounds"];
		if ([[self wod] rounds] != nil && [[[self wod] rounds] intValue] > 0) {
			[[cell detailTextLabel] setText:[[[self wod] rounds] stringValue]];
		}
		else {
			[[cell detailTextLabel] setText:@"<NUM OF ROUNDS HERE>"];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"TimeLimitCell"] ) {
		
		[[cell textLabel] setText:@"Time Limit"];
		if ( [[self wod] timelimit] != nil && [[[self wod] timelimit] intValue] > 0) {
			[[cell detailTextLabel] setText:[[[self wod] timelimit] stringValue]];
		}
		else {
			[[cell detailTextLabel] setText:@"<TIME LIMIT HERE>"];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"RepRoundsCell"] ) {
		
		[[cell textLabel] setText:@"Rep Rounds"];
		
	}
	else {
	}
	
}



- (void)logScoreViewController:(LogScoreViewController *)controller didFinishWithSave:(BOOL)save	{
	if (save) {		
		// Create a new WOD in the database with specific attributes:
		SCORE* score = (SCORE *)[NSEntityDescription insertNewObjectForEntityForName:@"score" inManagedObjectContext:managedObjectContext];
		[score setCompleted:[NSNumber numberWithInt:1]];
		[score setWod:[controller wod]];
		[score setDate:[controller date]]; 
		[score setNotes:[controller logNotes]];
		
		switch ([[[controller wod] score_type] intValue]) {
			case WOD_SCORE_TYPE_NONE:
				[score setTime:[NSNumber numberWithDouble:[controller time_in_seconds]]];
				break;
			case WOD_SCORE_TYPE_TIME:
				[score setTime:[NSNumber numberWithDouble:[controller time_in_seconds]]];
				break;
			case WOD_SCORE_TYPE_REPS:
				[score setReps:[NSNumber numberWithDouble:[[[controller scoreField] text] intValue]]];
				break;
			case WOD_SCORE_TYPE_RNDS:
				[score setRounds:[NSNumber numberWithDouble:[[[controller scoreField] text] intValue]]];
				break;
			default:
				break;
		}	
		
		NSLog(@"Saving score: %@",score);
		
		// Save the new WOD:
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(logScoreControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}		
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
	}
	
	// Clean up:
	[logScoreViewController release];
	[self setLogScoreViewController:nil];
	// Dismiss the modal view to return to the main list:
    [self dismissModalViewControllerAnimated:YES];
	
	
}

- (void)logScoreControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
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
    
	// Create and configure a fetch request with the 'wod' entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"score" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Root"];
	[self setFetchedResultsController:aFetchedResultsController];
	//	self.fetchedResultsController = aFetchedResultsController;
	[[self fetchedResultsController] setDelegate:self];
	//	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[sortDescriptors release];
	return fetchedResultsController;
}    

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [wodExerciseArray release];
	self.wodExerciseArray = nil;
	[wodRepRounds release];
	[wod release];
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[wodExerciseArray dealloc];
    [super dealloc];
}


@end
