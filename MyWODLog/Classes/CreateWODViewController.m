//
//  CreateWODViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateWODViewController.h"
#import	"EditViewController.h"


@implementation CreateWODViewController

@synthesize managedObjectContext, delegate, wodName, wodExerciseArray, wodNotes, wodType, readyToSave, saveButton, table;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self setWodExerciseArray:[NSMutableArray arrayWithCapacity:0]];
//		self.exerciseArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Create WOD"];



	// Configure the save and cancel buttons.
	[self setSaveButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)]];
	//saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	[[self saveButton] setEnabled:YES];
//	saveButton.enabled = YES;
	[[self navigationItem] setRightBarButtonItem:[self saveButton]];
///	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
//	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	[self evaluateSaveReadiness];
}

- (void)viewWillAppear:(BOOL)animated {

	// Register for exercises saved notifications
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc addObserver:self selector:@selector(exerciseSelectedNote:) name:@"ExerciseSelected" object:nil];
	[dnc addObserver:self selector:@selector(nameChangedNote:) name:@"EditSent" object:nil];
	[dnc addObserver:self selector:@selector(notesChangedNote:) name:@"NotesSent" object:nil];
	[dnc addObserver:self selector:@selector(typeChangedNote:) name:@"TypeSent" object:nil];
	
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
		
		//TODO: setWODType here!
		
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
//	self.navigationItem.backBarButtonItem = backButton;
	[[self navigationItem] setBackBarButtonItem:backButton];
	[backButton release];
	[[self navigationController] pushViewController:exercise_category animated:YES];
	
	[exercise_category release];

	
}

#pragma mark -
#pragma mark Notifications


- (void)exerciseSelectedNote:(NSNotification*)saveNotification {
	
	//[self dismissModalViewControllerAnimated:YES];
	NSDictionary *dict = [saveNotification userInfo];
	EXERCISE *e = [dict objectForKey:@"Exercise"];

	/*NSLog(@"NEW EXERCISE \n %@",e);
	NSLog(@"EXERCISES ARRAY1\n %@",self.wodExerciseArray);
	NSLog(@"ARRAY COUNT: %d\n",[[self wodExerciseArray] count]);
	
	NSLog(@"DICTIONARY CONTENTS \n %@",dict);
	NSLog(@"RAWR1");
	if (e == nil) {
		NSLog(@"E == NIL!");
	}*/
	
	[[self wodExerciseArray] addObject:e];
	
	/*NSLog(@"RAWR2");
	NSLog(@"EXERCISES ARRAY2\n %@",self.wodExerciseArray);
	NSLog(@"ARRAY COUNT2: %d\n",[[self wodExerciseArray] count]);
	*/
	//self.exerciseArray = [NSMutableArray arrayWithObject:e];
	[[self table] reloadData];
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc removeObserver:self name:@"ExerciseSelected" object:nil];
	
	[self evaluateSaveReadiness];
}


- (void)nameChangedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	[self setWodName:[dict objectForKey:@"Text"]];
	//	self.name = [dict objectForKey:@"Text"];
	NSLog(@"NAME %@ \n",[self wodName]);
	[[self table] reloadData];
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"EditSent" object:nil];
	
	[self evaluateSaveReadiness];
}


- (void)notesChangedNote:(NSNotification*)saveNotification {
	NSDictionary *dict = [saveNotification userInfo];

	[self setWodNotes:[dict objectForKey:@"Text"]];
	[[self table] reloadData];
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"NotesSent" object:nil];

	[self evaluateSaveReadiness];
}

- (void)typeChangedNote:(NSNotification*)saveNotification {
	NSDictionary *dict = [saveNotification userInfo];
	
	//NSString *stringType = [dict objectForKey:@"Text"];
	//int type = [stringType intValue];
	// + 1 is needed as it returns row value
	[self setWodType:[[dict objectForKey:@"Text"] intValue] + 1];
	[[self table] reloadData];
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"TypeSent" object:nil];
	
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
	
    return 3;
	
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    NSString *title = nil;
	
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case 0:
            title = @"Details";
            break;
        case 1:
            title = @"Exercises";
            break;
		case 2:
            title = @"Notes";
            break;
        default:
            break;
    }
	
    return title;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger rows;
	
	switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = [[self wodExerciseArray] count] + 1;
            break;
        case 2:
            rows = 1;
            break;			
        default:
            break;
    }
	
    return rows;
	
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([indexPath section] == 0 && [indexPath row] == 0) {
		
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
	else if ([indexPath section] == 0 && [indexPath row] == 1) {
		
		static NSString *TypeCellIdentifier = @"TypeCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];

		if (cell == nil) {
//			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimedCellIdentifier] autorelease];
//			switchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
//			[cell setAccessoryView : switchButton];
//			[switchButton release];
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:TypeCellIdentifier] autorelease];
			[cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		return cell;

	}
	else if ([indexPath section] == 1 && [indexPath row] < [[self wodExerciseArray] count] ) {
		
		static NSString *ExerciseCellIdentifier = @"ExerciseCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExerciseCellIdentifier];

		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ExerciseCellIdentifier] autorelease];
		}
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		return cell;

	}
	else if ([indexPath section] == 2) {
		
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
//			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
		}
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		return cell;

	}

}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	if ([indexPath section] == 0 && [indexPath row] == 0) {
		
		[[cell textLabel] setText:@"Name"];
		if ([self wodName] != nil) {
			
			[[cell detailTextLabel] setText:[self wodName]];
			
		}
		else {

			[[cell detailTextLabel] setText:@"<WOD NAME HERE>"];
			
		}
		
    }
	else if ([indexPath section] == 0 && [indexPath row] == 1) {

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
			default:
				subText = WOD_TYPE_TEXT_UNKNOWN;
				break;
		}
		
		[[cell detailTextLabel] setText:subText];
		
	}
	else if ([indexPath section] == 1 && [indexPath row] < [[self wodExerciseArray] count] ) {
		
		EXERCISE *exercise = (EXERCISE *)[wodExerciseArray objectAtIndex:[indexPath row]];
		[[cell textLabel] setText:[exercise name]];
		
	}
	else if ([indexPath section] == 2) {
		
		if ([self wodNotes] != nil && [[self wodNotes] length] > 0) {
			[[cell textLabel] setText:[self wodNotes]];
		} else {
			[[cell textLabel] setText:@"Add Notes..."];
		}


		
	} else {
		
		[[cell textLabel] setText:@"Add Exercise..."];
		
	}


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// Case 'WOD Name':
	if ([indexPath section] == 0 && [indexPath row] == 0) {
		
		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Name"];
		[controller setNotificationName:@"EditSent"];
		[controller setEditType:EDIT_TYPE_NORMAL];
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
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
		
	}
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
