//
//  ViewWODViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewWODViewController.h"


@implementation ViewWODViewController

@synthesize wod, scoredByLabel, wodExerciseArray, table, logButton; // removed the list label in order to add the tabel
@synthesize showNumRounds, showRepRounds, showTimeLimit;
@synthesize wodName, wodNotes, wodType, wodTimeLimit, wodNumRounds, wodRepRounds, wodScoreType;



- (id)init {
	//[self setTitle:@"<WOD Name>"];
	
	return self;
}


- (void)viewDidLoad {
	NSLog(@"view did load called \n");

	[self setLogButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(logScorePressed:)]];
	[[self logButton] setEnabled:YES];
	[[self navigationItem] setRightBarButtonItem:[self logButton]];
	[logButton release];
	
	//Assumes setCurrentWOD is called
	
	/*
	NSString *exerciseList = [[NSString alloc] init];
	
	NSEnumerator *enumer = [[wod exercises] objectEnumerator];
	EXERCISE* e;

	while ((e = (EXERCISE*)[enumer nextObject])) {

		if ([exerciseList length] > 0) {
			exerciseList = [NSString stringWithFormat:@"%@\n\n%@", exerciseList, [e name]];
		} else {
			exerciseList = [e name];
		}
		
	}
	//[myString stringByAppendingString:@" is just a test"];
	[[self exerciseListLabel] setText:exerciseList];*/
	
	// Fill the exercises array with all the WOD's exercsies
	//exerciseArray = [[[self wod] exercises] allObjects];
	//NSLog(@"%@\n", [[exerciseArray objectAtIndex:0] name]);
	//NSLog(@"count %d\n", [[self exerciseArray] count]);
}



- (void)setCurrentWOD:(WOD *)w {

	[self setWod:w];
	[self setWodName:[[self wod] name]];
	[self setWodType:[[self wod] score_type]];
	
	[self setTitle:[wod name]];

}



- (IBAction)logScorePressed:(id)sender {
	
	LogScoreViewController* logScore = [[LogScoreViewController alloc] init];

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
	
	NSInteger rows;
	
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
	else if ( [indexPath section] == VW_SECTION_DETAILS && [indexPath row] == 2 && [self wodType] == WOD_TYPE_RRFT ) {
		
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
			 ([self wodType] == WOD_TYPE_RFT || [self wodType] == WOD_TYPE_EMOTM || [self wodType] == WOD_TYPE_AMRAP) ) {
		
		static NSString *TypeCellIdentifier = @"TimeLimitCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			//[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
	else if ( [indexPath section] == VW_SECTION_DETAILS &&
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
	NSLog(@"SHOULDNT BE HERE\n");
	return 0; // Should never get to this point but the compiler complained
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
			EEXERCISE *eexercise = (EEXERCISE *)[wodExerciseArray objectAtIndex:[indexPath row]];
			NSString* exerciseText = nil;
			if ([[eexercise quantity] intValue] > 0) {
				exerciseText = [[NSString alloc] initWithFormat:@"%@ %@",[[eexercise quantity] stringValue],[[eexercise exercise] name]];
			} else {
				exerciseText = [[eexercise exercise] name];
			}

			
			[[cell textLabel] setText:exerciseText];
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"NotesCell"] ) {
		
		if ([self wodNotes] != nil && [[self wodNotes] length] > 0) {
			[[cell textLabel] setText:[self wodNotes]];
		} else {
			[[cell textLabel] setText:@"N/A"];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
