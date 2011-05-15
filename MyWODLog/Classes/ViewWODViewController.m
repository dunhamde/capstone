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

@synthesize wod, scoredByLabel, table, logButton; // removed the list label in order to add the tabel
@synthesize showNumRounds, showRepRounds, showTimeLimit;
@synthesize logScoreViewController, managedObjectContext, fetchedResultsController;
@synthesize	notesView, notesTitleLabel, notesTextView;

/*
- (id)init {
	self = [super init];
	return self;
}*/



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
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
		
    }
    return self;
}



- (void)viewDidLoad {

	[self setLogButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(logScorePressed:)]];
	[[self logButton] setEnabled:YES];
	[[self navigationItem] setRightBarButtonItem:[self logButton]];
	[logButton release];
	
}



- (void)setCurrentWOD:(WOD *)w {

	[self setWod:w];
	
	if ([[w timelimit] intValue] > 0) {
		[self setShowTimeLimit:YES];
	}
	
	[self setTitle:[[[self wod] name] capitalizedString]];

}



- (IBAction)logScorePressed:(id)sender {
	
	LogScoreViewController* logScore = [[LogScoreViewController alloc] init];
	
	[logScore setWod:[self wod]];
	[logScore setDelegate:self];
	[[self navigationController] pushViewController:logScore animated:YES];

	[logScore release];
	
}



#pragma mark -
#pragma mark Table View Controller Methods



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
			rows = [[[[self wod] eexercises] allObjects] count];
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
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == VW_SECTION_DETAILS && [indexPath row] == 2 && [[[self wod] type] intValue] == WOD_TYPE_RRFT ) {
		
		static NSString *TypeCellIdentifier = @"RepRoundsCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == VW_SECTION_DETAILS && [indexPath row] == 2 &&
			 ([[[self wod] type] intValue] == WOD_TYPE_RFT ||
			  [[[self wod] type] intValue] == WOD_TYPE_EMOTM ||
			  [[[self wod] type] intValue] == WOD_TYPE_AMRAP) ) {
		
		static NSString *TypeCellIdentifier = @"TimeLimitCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
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
			//[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == VW_SECTION_EXERCISES && [indexPath row] < [[[[self wod] eexercises] allObjects] count] ) {	
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
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
	}

	return nil;
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = [cell reuseIdentifier];
	
	if( [cellIdentifier isEqualToString:@"NameCell"] ) {
		
		[[cell textLabel] setText:@"Name"];
		
		if ([[self wod] name] != nil) {
			[[cell detailTextLabel] setText:[[[self wod] name] capitalizedString]];
		} else {
			[[cell detailTextLabel] setText:@"<No name found>"];
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
		
		if( [indexPath row] < [[[[self wod] eexercises] allObjects] count] ) {
			
			// Find the correct next eexercise
			NSEnumerator *enumer = [[[[self wod] eexercises] allObjects] objectEnumerator];
			EEXERCISE *eexercise = nil;
			
			while ( (eexercise = (EEXERCISE*)[enumer nextObject]) ) {
					if ( [indexPath row] + 1 == [[eexercise order] intValue] ) {
						break;
					}
			}
			
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
			[[cell detailTextLabel] setText:@"<No round limit>"];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"TimeLimitCell"] ) {
		
		[[cell textLabel] setText:@"Time Limit"];
		if ( [[self wod] timelimit] != nil && [[[self wod] timelimit] intValue] > 0) {
			NSString *timelimit = [[[self wod] timelimit] stringValue];
			[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ minutes", timelimit]];
		}
		else {
			[[cell detailTextLabel] setText:@"<No time limit>"];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];		
	NSString *cellIdentifier = [cell reuseIdentifier];
	
	// Case 'WOD Name':
	if( [cellIdentifier isEqualToString:@"NameCell"] ) {
		
	}
	// Case 'WOD Type':
	else if( [cellIdentifier isEqualToString:@"TypeCell"] ) {
		
	}
	// Case '<EXERCISE>':
	else if( [cellIdentifier isEqualToString:@"ExerciseCell"] ) {
		// Do nothing...
	}
	// Case 'Add Exericse...':
	else if( [cellIdentifier isEqualToString:@"AddCell"] ) {
		
	}
	// Case 'Notes...':
	else if( [cellIdentifier isEqualToString:@"NotesCell"] ) {
		
		 table.allowsSelection = NO;
		 
		 notesTextView.text = [[self wod] notes];
		 notesTitleLabel.text = @"Notes";		 
		 //  UIView *view = self.view;
		 CGRect frame = self.notesView.frame;
		 [UIView beginAnimations:nil context:NULL];
		 [UIView setAnimationDuration:.5];
		 
		 [self.view addSubview:notesView];
		 frame.origin.y = 116;
		 self.notesView.frame = frame;
		 
		 [UIView commitAnimations];
		
	}
	else if( [cellIdentifier isEqualToString:@"NumRoundsCell"] ) {
		
	}
	else if( [cellIdentifier isEqualToString:@"TimeLimitCell"] ) {
		
	}
	else if( [cellIdentifier isEqualToString:@"RepRoundsCell"] ) {
		
	}
	
}



#pragma mark -
#pragma mark Notes



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



#pragma mark -
#pragma mark Memory management



- (void)didReceiveMemoryWarning {
	
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
	
}



- (void)viewDidUnload {
	
    [super viewDidUnload];

	[wod release];

}



- (void)dealloc {
	
    [super dealloc];
	
}



@end
