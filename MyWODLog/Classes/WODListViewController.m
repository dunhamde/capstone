    //
//  WODListViewController.m
//  MyWODLog
//
//  Created by Derek on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WODListViewController.h"
#import "CreateWODViewController.h"


@implementation WODListViewController

@synthesize managedObjectContext,wodList;



- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Create an array of several temporarily hard coded WODs
	wodList = [NSMutableArray arrayWithObjects: @"Angie", @"Barbara", @"Chelsea", @"Cindy", @"Diane", nil];
	[wodList retain];
	// Set the nav bar to have the pre-fab'ed Edit button when
	// WODListViewController is on top of the stack
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	// Set the title of the nav bar to WOD List when WODListViewController
	// is on top of the stack
	[self setTitle:@"WOD List"];
	
	/*
	 Fetch existing events.
	 Create a fetch request; find the Event entity and assign it to the request; add a sort descriptor; then execute the fetch.
	 */
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"wod" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	[self setWodList:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
}

- (void)viewWillAppear {
	[self.tableView reloadData];
}


// Called when the '+' button is pressed while in editing mode. 
- (IBAction) createWOD {
	CreateWODViewController *cwvc = [[CreateWODViewController alloc] init];
	cwvc.managedObjectContext = [self managedObjectContext];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cwvc];
	
    [self.navigationController presentModalViewController:navController animated:YES];
	
	[cwvc release];
	[navController release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	
	[self.navigationItem setHidesBackButton:editing animated:YES];

	if (editing) {
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createWOD)];
		[self.navigationItem setLeftBarButtonItem:addButton animated:animated];
		[addButton release];
	}
	else {
		[self.navigationItem setLeftBarButtonItem:nil animated:NO];

	}



    
	
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section 
{
	int numberOfRows = [wodList count];
	// If we are editing, we will have one more row than we have possessions
	if ([self isEditing]) {
		numberOfRows++;
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	// Check for reusable cell first, use that if it exists
	UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
	if (!cell) {
		// Create an instance of UITableViewCell, with default appearance
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:@"UITableViewCell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Set the text on the cell with the description of the possession
	// that is at the nth index of possessions, where n=row this cell
	// will appear in the window
	
	// If the table view is filling a row with a possession in it, do as normal
	if ([indexPath row] < [wodList count]) {		 
		[[cell textLabel] setText:[[wodList objectAtIndex:[indexPath row]] description]];
	} else { // Otherwise, if we are editing we have one extra row...
		[[cell textLabel] setText:@"Add New WOD..."];
	}
	
	
	return cell;
}
- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath * )indexPath
{
	
	if (!vwvc) {
		vwvc = [[ViewWODViewController alloc] init];
	}
	[[self navigationController] pushViewController:vwvc animated:YES];

	
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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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
	self.wodList = nil; 
}


- (void)dealloc {
	[wodList release];
    [super dealloc];
}


@end
