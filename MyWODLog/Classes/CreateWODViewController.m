//
//  CreateWODViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateWODViewController.h"


@implementation CreateWODViewController

@synthesize managedObjectContext, name, scoreType, delegate, wodName, isEditing, saveButton, exerciseArray, table;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.exerciseArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Create WOD"];
	NSLog(@"VIEW DID LOAD \n");
	[self setIsEditing:NO];

	// Configure the save and cancel buttons.
	saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	saveButton.enabled = NO;
	self.navigationItem.rightBarButtonItem = saveButton;
	//[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	

	
}

- (void)viewWillAppear:(BOOL)animated {
	// Register for exercises saved notifications
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc addObserver:self selector:@selector(exerciseSelectedNote:) name:@"ExerciseSelected" object:nil];
	
	NSLog(@"exercises %@",self.exerciseArray);
	[name setPlaceholder:@"New WOD Name"];
//	name.placeholder = @"New WOD Name";
	//[name becomeFirstResponder];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	[self setWodName:[textField text]];
	//wod.name = textField.text;
	[self setIsEditing:NO];
//	isEditing = NO;

	// Enable saving if there is text in the field
	//  ?What if name is the same as another?
	//TODO:  if( name.text isn't already in the database )
	if ([name.text length] > 0) {
		[saveButton setEnabled:YES];
//		saveButton.enabled = YES;
	}
	
	return NO;
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
	[delegate createWODViewController:self didFinishWithSave:NO];
}



- (IBAction)save:(id)sender {
	
	// Check to see if that name doesn't already exist.
	NSString *queryString = [NSString stringWithFormat:@"name == '%@'", [name text]];
	
	// Create and configure a fetch request with the wod entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"wod" inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:queryString]];
	
	NSError *error = nil; 
	NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	NSLog(@"ADDING STUFF???");
	if( error || [array count] > 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"WOD Already Exists" message: @"Error, a WOD with that name already exists!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		alert = nil;
	
	// Confirm that a name has been entered
	} else if (![self isEditing]) {
		
		NSLog(@"Saved with text: %@", [name text]);
		
		//int scoreType;
		// Set the score type based on the UISwitch position
		if ( !(scoreSwitch.on) ) {
			[self setScoreType:WOD_SCORE_TYPE_TIME];
//			scoreType = WOD_SCORE_TYPE_TIME;
		} else {
			[self setScoreType:WOD_SCORE_TYPE_REPS];
//			scoreType = WOD_SCORE_TYPE_REPS;
		}
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


- (IBAction)startEditingMode {
	// Grey out save button here as well
	[saveButton setEnabled:NO];
	[self setIsEditing:YES];
//	saveButton.enabled = NO;
//	isEditing = YES;
}



#pragma mark -
#pragma mark More button operations



- (IBAction)addExercise
{
	ViewExerciseModesViewController* exercise_category = [[ViewExerciseModesViewController alloc] init];
	[exercise_category setManagedObjectContext:[self managedObjectContext]];
	//exercise.delegate = self;
	
	
	//TODO: This may need to be eventually entered back in... but modifed for Exercises/Modes
	
	/*  
	
	// Create a new managed object context for the new book -- set its persistent store coordinator to the same as that from the fetched results controller's context.
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
	
	createWODViewController.wod = (WOD *)[NSEntityDescription insertNewObjectForEntityForName:@"wod" inManagedObjectContext:addingContext];
	
	
	*/
	
//	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:exercise_category];
	
  //  [[self navigationController] presentModalViewController:navController animated:YES];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	[[self navigationController] pushViewController:exercise_category animated:YES];
	
	[exercise_category release];
	//[navController release];
}


#pragma mark -
#pragma mark Table View Controller stuff


- (void)exerciseSelectedNote:(NSNotification*)saveNotification {
	
	//[self dismissModalViewControllerAnimated:YES];
	NSDictionary *dict = [saveNotification userInfo];
	EXERCISE *e = [dict objectForKey:@"Exercise"];
	NSLog(@"NEW EXERCISE \n %@",e);
	NSLog(@"EXERCISES ARRAY1\n %@",self.exerciseArray);
	NSLog(@"ARRAY COUNT: %d\n",[[self exerciseArray] count]);

	NSLog(@"DICTIONARY CONTENTS \n %@",dict);
	NSLog(@"RAWR1");
	if (e == nil) {
		NSLog(@"E == NIL!");
	}
	[[self exerciseArray] addObject:e];
	NSLog(@"RAWR2");
	NSLog(@"EXERCISES ARRAY2\n %@",self.exerciseArray);
	NSLog(@"ARRAY COUNT2: %d\n",[[self exerciseArray] count]);

	//self.exerciseArray = [NSMutableArray arrayWithObject:e];
	[[self table] reloadData];
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];

	[dnc removeObserver:self name:@"ExerciseSelected" object:nil];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
// Customize the number of rows in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
        default:
            break;
    }
    return title;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger rows;
	switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = [[self exerciseArray] count];
            break;
        default:
            break;
    }
    return rows;;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (indexPath.section == 0 && indexPath.row == 0) {
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
    }
	else if (indexPath.section == 0 && indexPath.row == 1) {
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
	}
	else if(indexPath.section == 1) {
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
	}
    // Configure the cell.
	[self configureCell:cell atIndexPath:indexPath];

	
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0 && indexPath.row == 0) {
		cell.textLabel.text = @"Name";
		cell.detailTextLabel.text = @"WOD Name";
    }
	else if (indexPath.section == 0 && indexPath.row == 1) {
		cell.textLabel.text = @"Timed";
	}
	else if(indexPath.section == 1) {
		EXERCISE *exercise = (EXERCISE *)[exerciseArray objectAtIndex:indexPath.row];
		NSLog(@" EXERCISE INTO TABLE %@",exercise);
		cell.textLabel.text = [exercise name];
	}

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];
	NSLog(@"UNLOADED CREATEWOD\n");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[saveButton release];
	[self setSaveButton:nil];
//	saveButton = nil;
}



- (void)dealloc {
	NSLog(@"DEALLOCED CREATEWOD\n");

    [super dealloc];
}

@end
