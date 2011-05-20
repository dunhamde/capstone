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
@synthesize wodName, wodExerciseArray, wodExerciseQtyArray, wodExerciseMetricArray, wodExerciseNameArray, wodNotes, wodType, wodTimeLimit, wodNumRounds, wodRepRounds, wodScoreType;
@synthesize repRoundList;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
		
		[self setWodExerciseArray:[NSMutableArray arrayWithCapacity:0]];
		[self setWodExerciseQtyArray:[NSMutableArray arrayWithCapacity:0]];
		[self setWodExerciseMetricArray:[NSMutableArray arrayWithCapacity:0]];
		[self setWodExerciseNameArray:[NSMutableArray arrayWithCapacity:0]];
		[self setWodRepRounds:[NSMutableArray arrayWithCapacity:0]];
		
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
	NSLog(@"VIEW WILL APPEAR");

	// Register for exercises saved notifications
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc addObserver:self selector:@selector(exerciseSelectedNote:) name:@"ExerciseSelected" object:nil];
	[dnc addObserver:self selector:@selector(nameChangedNote:) name:@"EditSent" object:nil];
	[dnc addObserver:self selector:@selector(notesChangedNote:) name:@"NotesSent" object:nil];
	[dnc addObserver:self selector:@selector(typeChangedNote:) name:@"TypeSent" object:nil];
	[dnc addObserver:self selector:@selector(timeLimitChangedNote:) name:@"TimeLimitSent" object:nil];
	[dnc addObserver:self selector:@selector(numRoundsChangedNote:) name:@"NumRoundsSent" object:nil];
	[dnc addObserver:self selector:@selector(repRoundsChangedNote:) name:@"RepRoundsSent" object:nil];

	// Handle Rep Round (if need be)
	if ([self repRoundList] != nil) {

		//TODO: Fix memory leak here (repRoundList cannot be released here... or crash later on)
		// Probably need to actually copy elements into wodRepRounds
		//[self setWodRepRounds:[[self repRoundList] elements]];
		//[[self wodRepRounds] release];
		//[self setWodRepRounds:nil];
		
		
		// Posible solution may be:  Make a get copy of elements method for ListEditVC
		//  and remove the setter/getters for it (but make a set default elements method)
		
		
		// SOLUTION:  THROW UP MEMORY LEAKS
		[self setWodRepRounds:[NSMutableArray arrayWithCapacity:0]];
		[[self wodRepRounds] addObjectsFromArray:[[self repRoundList] elements]];
		
		// THIS BELOW IS NECESSARY YET CRASHES THE PROGRAM....
	//	[[self repRoundList] release];
	//	[self setRepRoundList:nil];
		
		
		[[self table] reloadData];


	}
	NSLog(@"END VIEW WILL APPEAR");
	 
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
	
	[delegate createWODViewController:self didFinishWithSave:NO];
	
}



- (IBAction)save:(id)sender {
	NSLog(@"CW SAVE");
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

		[delegate createWODViewController:self didFinishWithSave:YES];
	} else {
		/*
		 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network error" message: @"Error sending your info to the server" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		 
		 [someError show];
		 [someError release];
		 */
	}
	[fetchRequest release];
	NSLog(@"CW SAVE END");
}



- (void)addExerciseElement:(EXERCISE*)exercise quantity:(NSNumber*)qty metric:(NSString*)metric {

	NSString *ename = [exercise name];

	[[self wodExerciseArray] addObject:exercise];
	
	if (qty == nil) {
		[[self wodExerciseQtyArray] addObject:[[NSNumber alloc] initWithInt:0]];
	} else {
		[[self wodExerciseQtyArray] addObject:qty];
	}
	
	if (metric == nil) {
		[[self wodExerciseMetricArray] addObject:@""];
	} else {
		[[self wodExerciseMetricArray] addObject:metric];
	}
	
	// If there is a metric, then convert the name to include it
	if ([[exercise requiresMetric] boolValue]) {
		
		NSRange range = [[exercise name] rangeOfString:@"#"];
		ename = [[exercise name] stringByReplacingCharactersInRange:range withString:metric];
		
	}
	
	[[self wodExerciseNameArray] addObject:ename];

	[[self table] reloadData];


	// See if this change will allow us to save
	[self evaluateSaveReadiness];

}


#pragma mark -
#pragma mark Notifications


- (void)exerciseSelectedNote:(NSNotification*)saveNotification {

	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'Exercises' (and its quantity and metric) and refresh the table
	EXERCISE *e = (EXERCISE*)[dict objectForKey:@"Exercise"];
	
	NSNumber *q = nil;
	if ([self quantifyExercises]) {
		NSString *qty = (NSString*)[dict objectForKey:@"Quantity"];
		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		q = [f numberFromString:qty];
		[f release];
	}
	
	NSString *m = (NSString*)[dict objectForKey:@"Metric"];


	
	if ([e requiresMetric] > 0) {
		[self addExerciseElement:e quantity:q metric:m];
	} else {
		[self addExerciseElement:e quantity:q metric:nil];
	}

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
			[self setQuantifyExercises:NO];
			[self setWodScoreType:WOD_SCORE_TYPE_RNDS];
			break;
		case WOD_TYPE_EMOTM:
			[self setShowNumRounds:NO];
			[self setShowRepRounds:NO];
			[self setShowTimeLimit:YES];
			[self setQuantifyExercises:YES];
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
	
	NSInteger rows = 0;
	
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
		
	}
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
			//[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			
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
			//[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
			
			NSString *exerciseText = nil;
			NSNumber *qty = (NSNumber *)[[self wodExerciseQtyArray] objectAtIndex:[indexPath row]];
			//EXERCISE *exercise = (EXERCISE *)[[self wodExerciseArray] objectAtIndex:[indexPath row]];
			NSString *ename = (NSString *)[[self wodExerciseNameArray] objectAtIndex:[indexPath row]];

			if ([qty intValue] > 0) {
				exerciseText = [[NSString alloc] initWithFormat:@"%@ %@",qty,ename];
			} else {
				exerciseText = ename;
			}						
			
			[[cell textLabel] setText:exerciseText];
			
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
		
		[[cell textLabel] setText:@"Rep Rnds"];

		if ([self wodRepRounds] != nil) {

			NSString *repRoundsString = [[NSString alloc] init];

			NSEnumerator *enumer = [[self wodRepRounds] objectEnumerator];
			NSNumber *n;
			int rrcount = [[self wodRepRounds] count];
			
			while ((n = (NSNumber*)[enumer nextObject])) {
				
				if ([repRoundsString length] > 0) {
					if (rrcount > CW_MAX_RROUND_COUNT_FOR_SPACING) {
						repRoundsString = [NSString stringWithFormat:@"%@-%@", repRoundsString, [n stringValue]];
					} else {
						repRoundsString = [NSString stringWithFormat:@"%@ - %@", repRoundsString, [n stringValue]];
					}
				} else {
					repRoundsString = [n stringValue];
				}
			}
			
			[[cell detailTextLabel] setText:repRoundsString];			
		} else {
			[[cell detailTextLabel] setText:@""];
		}

	}
	else {
		//[[cell textLabel] setText:@"Add Exercise..."];
	}

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];		
	NSString *cellIdentifier = [cell reuseIdentifier];
	
	// Case 'WOD Name':
	if( [cellIdentifier isEqualToString:@"NameCell"] ) {
		
		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Name"];
		[controller setPlaceholder:@"Name"];
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
		[controller release];
		
	}
	// Case '<EXERCISE>':
	else if( [cellIdentifier isEqualToString:@"ExerciseCell"] ) {
		// Do nothing...
	}
	// Case 'Add Exericse...':
	else if( [cellIdentifier isEqualToString:@"AddCell"] ) {
		
		ViewExerciseModesViewController* controller = [[ViewExerciseModesViewController alloc] init];
		[controller setManagedObjectContext:[self managedObjectContext]];
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		
		[[self navigationItem] setBackBarButtonItem:backButton];
		[backButton release];
		
		[controller setQuantify:[self quantifyExercises]];
		[[self navigationController] pushViewController:controller animated:YES];
		
		[controller release];
				
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
		[controller setPlaceholder:@"Rounds"];
		[controller setNotificationName:@"NumRoundsSent"];
		[controller setEditType:EDIT_TYPE_NUMBER];
		[controller setDefaultText:[self wodNumRounds]];
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
		
	}
	else if( [cellIdentifier isEqualToString:@"TimeLimitCell"] ) {

		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Time Limit"];
		[controller setPlaceholder:@"Time Limit (in minutes)"];
		[controller setNotificationName:@"TimeLimitSent"];
		[controller setEditType:EDIT_TYPE_NUMBER];
		[controller setDefaultText:[self wodTimeLimit]];
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
		
	}
	else if( [cellIdentifier isEqualToString:@"RepRoundsCell"] ) {

		ListEditViewController *controller = [[ListEditViewController alloc] init];
		
		[controller setTitleName:@"Rep Rounds"];
		[controller setNotificationName:@"RepRoundsSent"];
		[controller setAddTitleName:@"Add Round"];
		[controller setElements:[self wodRepRounds]]; // Set some default elements
		[[self navigationController] pushViewController:controller animated:YES];		

		[self setRepRoundList:controller];
		
		[controller release];

	}
	
	[[self table] deselectRowAtIndexPath:indexPath animated:YES];

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
	[wodExerciseArray release];
	[wodExerciseQtyArray release];
	[wodExerciseMetricArray release];
	[wodRepRounds release];
	[self setSaveButton:nil];

}



- (void)dealloc {
    [super dealloc];
}

@end
