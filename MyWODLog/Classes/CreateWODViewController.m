//
//  CreateWODViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateWODViewController.h"



@implementation CreateWODViewController

@synthesize managedObjectContext, delegate, saveButton, table;
@synthesize readyToSave, quantifyExercises, showNumRounds, showRepRounds, showTimeLimit;
@synthesize wodName, wodExerciseArray, wodNotes, wodType, wodTimeLimit, wodNumRounds, wodRepRounds, wodScoreType;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
		
		[self setWodExerciseArray:[NSMutableArray arrayWithCapacity:0]];
		
    }
	
    return self;
	
}



- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self setTitle:@"Create WOD"];

	// Configure the save and cancel buttons.
	[self setSaveButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)]];
	[[self saveButton] setEnabled:YES];
	[[self navigationItem] setRightBarButtonItem:[self saveButton]];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release];
	
	// Default flag values:
	[self setShowNumRounds:NO];
	[self setShowRepRounds:NO];
	[self setShowTimeLimit:NO];
	[self setQuantifyExercises:YES];
	
	[self evaluateSaveReadiness];
	
}

- (void)viewWillAppear:(BOOL)animated {

	// Register for exercises saved notifications
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc addObserver:self selector:@selector(exerciseSelectedNote:) name:@"ExerciseSelected" object:nil];
	[dnc addObserver:self selector:@selector(nameChangedNote:) name:@"EditSent" object:nil];
	[dnc addObserver:self selector:@selector(notesChangedNote:) name:@"NotesSent" object:nil];
	[dnc addObserver:self selector:@selector(typeChangedNote:) name:@"TypeSent" object:nil];
	[dnc addObserver:self selector:@selector(timeLimitChangedNote:) name:@"TimeLimitSent" object:nil];
	[dnc addObserver:self selector:@selector(numRoundsChangedNote:) name:@"NumRoundsSent" object:nil];
	[dnc addObserver:self selector:@selector(repRoundsChangedNote:) name:@"RepRoundsSent" object:nil];
	
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
	
	[delegate createWODViewController:self didFinishWithSave:NO];
	
}



- (IBAction)save:(id)sender {

	// Error check that save is possible:
	if ([self wodName] == nil) {
		return;
	}
	
	// Check to see if that name doesn't already exist.
	NSString *queryString = [NSString stringWithFormat:@"name == '%@'", [self wodName] ];
	
	// Create and configure a fetch request with the wod entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"wod" inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:queryString]];
	
	NSError *error = nil; 
	NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	// Throw up an error message if the WOD already exists.
	if( error || [array count] > 0) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"WOD Already Exists" message: @"Error, a WOD with that name already exists!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		alert = nil;
	
	// Confirm that a name has been entered
	} else if ([self readyToSave]) {
		
		NSLog(@"Saved with text: %@", [self wodName]);
		
		//int scoreType;
		// Set the score type based on the UISwitch position
		/*
		if ( (switchButton.on) ) {
			[self setWodType:WOD_SCORE_TYPE_TIME];
		} else {
			[self setWodType:WOD_SCORE_TYPE_REPS];
		}*/
	//	[wod setScore_type:[NSNumber numberWithInt:scoreType]];

		[delegate createWODViewController:self didFinishWithSave:YES];
	} else {
		/*
		 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network error" message: @"Error sending your info to the server" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		 
		 [someError show];
		 [someError release];
		 */
	}
	
}


#pragma mark -
#pragma mark More button operations



- (IBAction)addExercise
{
	
	ViewExerciseModesViewController* exercise_category = [[ViewExerciseModesViewController alloc] init];
	[exercise_category setManagedObjectContext:[self managedObjectContext]];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

	[[self navigationItem] setBackBarButtonItem:backButton];
	[backButton release];
	[[self navigationController] pushViewController:exercise_category animated:YES];
	
	[exercise_category release];
	
}

#pragma mark -
#pragma mark Notifications


- (void)exerciseSelectedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'Exercises' and refresh the table
	EXERCISE *e = [dict objectForKey:@"Exercise"];
	[[self wodExerciseArray] addObject:e];
	[[self table] reloadData];
	
	// Remove the notifcation
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"ExerciseSelected" object:nil];
	
	// See if this change will allow us to save
	[self evaluateSaveReadiness];
	
}


- (void)nameChangedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'WOD Name' and refresh the table
	[self setWodName:[dict objectForKey:@"Text"]];
	[[self table] reloadData];

	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"EditSent" object:nil];
	
	// See if this change will allow us to save
	[self evaluateSaveReadiness];
	
}


- (void)notesChangedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];

	// Update 'Notes' and refresh the table
	[self setWodNotes:[dict objectForKey:@"Text"]];
	[[self table] reloadData];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"NotesSent" object:nil];

	// See if this change will allow us to save
	[self evaluateSaveReadiness];
}

- (void)typeChangedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'WOD Type', update flags, and then refresh the table
	[self setWodType:[[dict objectForKey:@"Text"] intValue] + 1];  	// + 1 converts index to position
	
	switch ([self wodType]) {
		case WOD_TYPE_TIME:
			[self setShowNumRounds:NO];
			[self setShowRepRounds:NO];
			[self setShowTimeLimit:NO];
			[self setQuantifyExercises:YES];
			[self setWodScoreType:WOD_SCORE_TYPE_TIME];
			break;
		case WOD_TYPE_RFT:
			[self setShowNumRounds:YES];
			[self setShowRepRounds:NO];
			[self setShowTimeLimit:YES];
			[self setQuantifyExercises:YES];
			[self setWodScoreType:WOD_SCORE_TYPE_TIME];
			break;
		case WOD_TYPE_RRFT:
			[self setShowNumRounds:NO];
			[self setShowRepRounds:YES];
			[self setShowTimeLimit:NO];
			[self setQuantifyExercises:NO];
			[self setWodScoreType:WOD_SCORE_TYPE_TIME];
			break;
		case WOD_TYPE_RFMR:
			[self setShowNumRounds:NO];
			[self setShowRepRounds:YES];
			[self setShowTimeLimit:NO];
			[self setQuantifyExercises:NO];
			[self setWodScoreType:WOD_SCORE_TYPE_REPS];
			break;
		case WOD_TYPE_AMRAP:
			[self setShowNumRounds:NO];
			[self setShowRepRounds:NO];
			[self setShowTimeLimit:YES];  // Although it is optional
			[self setQuantifyExercises:YES];
			[self setWodScoreType:WOD_SCORE_TYPE_RNDS];
			break;
		case WOD_TYPE_EMOTM:
			[self setShowNumRounds:NO];
			[self setShowRepRounds:NO];
			[self setShowTimeLimit:YES];
			[self setQuantifyExercises:YES];
			//TODO: CHECK TO SEE HOW THIS IS SCORED!
			[self setWodScoreType:WOD_SCORE_TYPE_NONE];
			break;
		default:
			[self setShowNumRounds:NO];
			[self setShowRepRounds:NO];
			[self setShowTimeLimit:NO];
			[self setQuantifyExercises:YES];
			[self setWodScoreType:WOD_SCORE_TYPE_TIME];
			break;
	}
	
	[[self table] reloadData];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"TypeSent" object:nil];
	
	// See if this change will allow us to save
	[self evaluateSaveReadiness];
	
}

- (void)timeLimitChangedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'Time Limit' and refresh the table
	[self setWodTimeLimit:[dict objectForKey:@"Text"]];
	[[self table] reloadData];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"TimeLimitSent" object:nil];
	
	// See if this change will allow us to save
	[self evaluateSaveReadiness];
	
}

- (void)numRoundsChangedNote:(NSNotification*)saveNotification {

	NSDictionary *dict = [saveNotification userInfo];
	
	// Update '# Rounds' and refresh the table
	[self setWodNumRounds:[dict objectForKey:@"Text"]];
	[[self table] reloadData];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"NumRoundsSent" object:nil];
	
	// See if this change will allow us to save
	[self evaluateSaveReadiness];

}

- (void)repRoundsChangedNote:(NSNotification*)saveNotification {

//	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'Rep Rounds' and refresh the table
//	[self setWodNumRounds[dict objectForKey:@"Text"]];
	[[self table] reloadData];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"RepRoundsSent" object:nil];
	
	// See if this change will allow us to save
	[self evaluateSaveReadiness];

}



#pragma mark -
#pragma mark Misc. Methods

- (void)evaluateSaveReadiness {
	
	BOOL activate = NO;

	// Should the user be able to press 'Save' yet?
	if ( [self wodName] != nil && [[self wodName] length] > 0 ) {
		if ([self wodType] > 0) {

			activate = YES;
			
		}
	}
	
	// Switch On/Off save button depending on conditions:
	if (activate) {
		// Activate save button
		[[self saveButton] setEnabled:YES];
		[self setReadyToSave:YES];
	} else {
		// Grey out (deactivate) the save button
		[[self saveButton] setEnabled:NO];
		[self setReadyToSave:NO];
	}


}


#pragma mark -
#pragma mark Table View Controller stuff



// Customize the number of rows in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return CW_NUM_SECTIONS;
	
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    NSString *title = nil;
	
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case CW_SECTION_DETAILS:
            title = CW_SECTION_TITLE_DETAILS;
            break;
        case CW_SECTION_EXERCISES:
            title = CW_SECTION_TITLE_EXERCISES;
            break;
		case CW_SECTION_NOTES:
            title = CW_SECTION_TITLE_NOTES;
            break;
        default:
            break;
    }
	
    return title;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger rows;
	
	switch (section) {
        case CW_SECTION_DETAILS:
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
        case CW_SECTION_EXERCISES:
            rows = [[self wodExerciseArray] count] + 1;
            break;
        case CW_SECTION_NOTES:
            rows = 1;
            break;			
        default:
            break;
    }
	
    return rows;
	
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ( [indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 0 ) {
		
		static NSString *NameCellIdentifier = @"NameCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCellIdentifier];

		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:NameCellIdentifier] autorelease];
			[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;

    }
	else if ( [indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 1 ) {
		
		static NSString *TypeCellIdentifier = @"TypeCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];

		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;

	}
	else if ( [indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 2 && [self wodType] == WOD_TYPE_RRFT ) {
		
		static NSString *TypeCellIdentifier = @"RepRoundsCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}
	else if ( [indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 2 &&
			 ([self wodType] == WOD_TYPE_RFT || [self wodType] == WOD_TYPE_EMOTM || [self wodType] == WOD_TYPE_AMRAP) ) {
		
		static NSString *TypeCellIdentifier = @"TimeLimitCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}/*
	else if ( [indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 2 && [self wodType] == WOD_TYPE_RFMR ) {
		
		static NSString *TypeCellIdentifier = @"NumRoundsCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
	}*/
	else if ( [indexPath section] == CW_SECTION_DETAILS &&
			 ([indexPath row] == 3 ||([indexPath row] == 2 && [self wodType] == WOD_TYPE_RFMR)) ) {
		
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
	else if ( [indexPath section] == CW_SECTION_EXERCISES && [indexPath row] < [[self wodExerciseArray] count] ) {
		
		static NSString *ExerciseCellIdentifier = @"ExerciseCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExerciseCellIdentifier];

		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ExerciseCellIdentifier] autorelease];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;

	}
	else if ( [indexPath section] == CW_SECTION_NOTES ) {
		
		static NSString *NotesCellIdentifier = @"NotesCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NotesCellIdentifier];
		
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NotesCellIdentifier] autorelease];
			[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
			
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
	}
	else {
		
		static NSString *AddCellIdentifier = @"AddCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];

		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier] autorelease];
			[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;

	}

}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	// Can't we do this by cell name instead of section/row numbers?
	// i.e.:  [cell reuseIdentifier]  << returns a string
	
	NSString *cellIdentifier = [cell reuseIdentifier];
	
	if( [cellIdentifier isEqualToString:@"NameCell"] ) {

		[[cell textLabel] setText:@"Name"];
		
		if ([self wodName] != nil) {
			[[cell detailTextLabel] setText:[self wodName]];
		} else {
			[[cell detailTextLabel] setText:@"<WOD NAME HERE>"];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"TypeCell"] ) {
		
		[[cell textLabel] setText:@"Type"];
		
		NSString *subText = nil;
		switch ([self wodType]) {
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
			EXERCISE *exercise = (EXERCISE *)[wodExerciseArray objectAtIndex:[indexPath row]];
			[[cell textLabel] setText:[exercise name]];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"AddCell"] ) {
		
		[[cell textLabel] setText:@"Add Exercise..."];
		
	}
	else if( [cellIdentifier isEqualToString:@"NotesCell"] ) {
		
		if ([self wodNotes] != nil && [[self wodNotes] length] > 0) {
			[[cell textLabel] setText:[self wodNotes]];
		} else {
			[[cell textLabel] setText:@"Add Notes..."];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"NumRoundsCell"] ) {
		
		[[cell textLabel] setText:@"# Rounds"];
		if ([self wodNumRounds] != nil && [[self wodNumRounds] length] > 0) {
			[[cell detailTextLabel] setText:[self wodNumRounds]];
		}
		else {
			[[cell detailTextLabel] setText:@"<NUM OF ROUNDS HERE>"];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"TimeLimitCell"] ) {
		
		[[cell textLabel] setText:@"Time Limit"];
		if ([self wodTimeLimit] != nil && [[self wodTimeLimit] length] > 0) {
			[[cell detailTextLabel] setText:[self wodTimeLimit]];
		}
		else {
			[[cell detailTextLabel] setText:@"<TIME LIMIT HERE>"];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"RepRoundsCell"] ) {
		
		[[cell textLabel] setText:@"Rep Rounds"];
		
	}
//	else if( [cellIdentifier isEqualToString:@""] ) {
//	}
	else {
		//[[cell textLabel] setText:@"Add Exercise..."];
	}
	
	/*
	if ([indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 0) {
		
		[[cell textLabel] setText:@"Name"];
		
		if ([self wodName] != nil) {
			
			[[cell detailTextLabel] setText:[self wodName]];
			
		}
		else {

			[[cell detailTextLabel] setText:@"<WOD NAME HERE>"];
			
		}
		
    }
	else if ([indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 1) {

		[[cell textLabel] setText:@"Type"];
		
		NSString *subText = nil;
		switch ([self wodType]) {
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
	else if ([indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 2) {
		
		
		
	}
	else if ([indexPath section] == CW_SECTION_DETAILS && [indexPath row] == 3) {
		
		[[cell textLabel] setText:@"# Rounds"];
		if ([self wodNumRounds] != nil && [[self wodNumRounds] length] > 0) {
			[[cell detailTextLabel] setText:[self wodNumRounds]];
		}
		else {
			[[cell detailTextLabel] setText:@"<NUM OF ROUNDS HERE>"];
		}

	}
	else if ([indexPath section] == CW_SECTION_EXERCISES && [indexPath row] < [[self wodExerciseArray] count] ) {
		
		EXERCISE *exercise = (EXERCISE *)[wodExerciseArray objectAtIndex:[indexPath row]];
		[[cell textLabel] setText:[exercise name]];
		
	}
	else if ([indexPath section] == CW_SECTION_NOTES) {
		
		if ([self wodNotes] != nil && [[self wodNotes] length] > 0) {
			[[cell textLabel] setText:[self wodNotes]];
		} else {
			[[cell textLabel] setText:@"Add Notes..."];
		}


		
	} else {
		
		[[cell textLabel] setText:@"Add Exercise..."];
		
	}
	 */

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];		
	NSString *cellIdentifier = [cell reuseIdentifier];
	
	// Case 'WOD Name':
	if( [cellIdentifier isEqualToString:@"NameCell"] ) {
		
		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Name"];
		[controller setNotificationName:@"EditSent"];
		[controller setEditType:EDIT_TYPE_NORMAL];
		[controller setDefaultText:[self wodName]];
		[[self navigationController] pushViewController:controller animated:YES];
		
		[controller release];
		
	}
	// Case 'WOD Type':
	else if( [cellIdentifier isEqualToString:@"TypeCell"] ) {
		
		SelectWODTypeViewController *controller = [[SelectWODTypeViewController alloc] init];
		
		// Set Back Button:
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		[[self navigationItem] setBackBarButtonItem:backButton];
		[backButton release];
		
		[[self navigationController] pushViewController:controller animated:YES];
		
	}
	// Case '<EXERCISE>':
	else if( [cellIdentifier isEqualToString:@"ExerciseCell"] ) {
		// Do nothing...
	}
	// Case 'Add Exericse...':
	else if( [cellIdentifier isEqualToString:@"AddCell"] ) {
		
		ViewExerciseModesViewController* exercise_category = [[ViewExerciseModesViewController alloc] init];
		[exercise_category setManagedObjectContext:[self managedObjectContext]];
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		
		[[self navigationItem] setBackBarButtonItem:backButton];
		[backButton release];
		
		[[self navigationController] pushViewController:exercise_category animated:YES];
		
		[exercise_category release];
		
	}
	// Case 'Add Notes...':
	else if( [cellIdentifier isEqualToString:@"NotesCell"] ) {

		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Notes"];
		[controller setNotificationName:@"NotesSent"];
		[controller setEditType:EDIT_TYPE_TEXTBOX];
		[controller setDefaultText:[self wodNotes]];
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
		
	}
	else if( [cellIdentifier isEqualToString:@"NumRoundsCell"] ) {
		
		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Number of Rounds"];
		[controller setNotificationName:@"NumRoundsSent"];
		[controller setEditType:EDIT_TYPE_NUMBER];
		[controller setDefaultText:[self wodNumRounds]];
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
		
	}
	else if( [cellIdentifier isEqualToString:@"TimeLimitCell"] ) {

		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Time Limit"];
		[controller setNotificationName:@"TimeLimitSent"];
		[controller setEditType:EDIT_TYPE_NUMBER];
		[controller setDefaultText:[self wodTimeLimit]];
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
		
	}
	else if( [cellIdentifier isEqualToString:@"RepRoundsCell"] ) {

		//TODO:  Change this soon
		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Rep Rounds"];
		[controller setNotificationName:@"RepRoundsSent"];
		[controller setEditType:EDIT_TYPE_NUMBER];
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
		
	}
	

	/*
	// Case 'WOD Name':
	if ([indexPath section] == 0 && [indexPath row] == 0) {
		
		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Name"];
		[controller setNotificationName:@"EditSent"];
		[controller setEditType:EDIT_TYPE_NORMAL];
		[controller setDefaultText:[self wodName]];
		[[self navigationController] pushViewController:controller animated:YES];

		[controller release];	
	}
	// Case 'WOD Type':
	else if ([indexPath section] == 0 && [indexPath row] == 1) {
		
		SelectWODTypeViewController *controller = [[SelectWODTypeViewController alloc] init];
		
		// Set Back Button:
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		[[self navigationItem] setBackBarButtonItem:backButton];
		[backButton release];
		
		[[self navigationController] pushViewController:controller animated:YES];
		
	}
	// Case 'Add Exericse...':
	else if ([indexPath section] == 1 && [indexPath row] == [[self wodExerciseArray] count] ) {
		
		ViewExerciseModesViewController* exercise_category = [[ViewExerciseModesViewController alloc] init];
		[exercise_category setManagedObjectContext:[self managedObjectContext]];
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		
		[[self navigationItem] setBackBarButtonItem:backButton];
		[backButton release];
		
		[[self navigationController] pushViewController:exercise_category animated:YES];
		
		[exercise_category release];
		
	}
	// Case 'Add Notes...':
	else if ([indexPath section] == 2 && [indexPath row] == 0) {
		
		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Notes"];
		[controller setNotificationName:@"NotesSent"];
		[controller setEditType:EDIT_TYPE_TEXTBOX];
		[controller setDefaultText:[self wodNotes]];
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
		
	} */
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[saveButton release];
	[self setSaveButton:nil];

}



- (void)dealloc {
    [super dealloc];
}

@end
