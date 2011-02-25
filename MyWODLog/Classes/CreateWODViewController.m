//
//  CreateWODViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateWODViewController.h"


@implementation CreateWODViewController

@synthesize managedObjectContext, name, delegate, wod, isEditing, saveButton;

/*- (id)init {
	// Call the superclass's designated initializer
	[super initWithStyle:UITableViewStyleGrouped];
	

	//[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	// Set the title of the nav bar to WOD List when WODListViewController
	// is on top of the stack
	[self setTitle:@"Create WOD"];
	
	return self;
}*/
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

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Create WOD"];
	
	isEditing = NO;
	
	// Configure the save and cancel buttons.
	saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	saveButton.enabled = NO;
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}

- (void)viewWillAppear:(BOOL)animated {
	name.placeholder = @"New WOD Name";
	//[name becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	wod.name = textField.text;
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
	
	// Confirm that a name has been entered
	if (!isEditing) {
		
		NSLog(@"Saved with text: %@", name.text);
		
		int scoreType;
		// Set the score type based on the UISwitch position
		if ( !(scoreSwitch.on) ) {
			scoreType = WOD_SCORE_TYPE_TIME;
		} else {
			scoreType = WOD_SCORE_TYPE_REPS;
		}
		[wod setScore_type:[NSNumber numberWithInt:scoreType]];

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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 2;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the book's title
	cell.textLabel.text = @"<AN EXERCISE HERE>";
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
	saveButton = nil;
}



- (void)dealloc {
    [super dealloc];
}


@end
