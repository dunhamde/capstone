    //
//  WODListViewController.m
//  MyWODLog
//
//  Created by Derek on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WODListViewController.h"


@implementation WODListViewController


- (id)init {
	// Call the superclass's designated initializer
	[super initWithStyle:UITableViewStyleGrouped];
	
	// Create an array of several temporarily hard coded WODs
	wodlist = [NSMutableArray arrayWithObjects: @"Angie", @"Barbara", @"Chelsea", @"Cindy", @"Diane", nil];
	[wodlist retain];
	// Set the nav bar to have the pre-fab'ed Edit button when
	// WODListViewController is on top of the stack
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	// Set the title of the nav bar to WOD List when WODListViewController
	// is on top of the stack
	[self setTitle:@"WOD List"];
	
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
	return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section 
{
	int numberOfRows = [wodlist count];
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
	if ([indexPath row] < [wodlist count]) {		 
		[[cell textLabel] setText:[[wodlist objectAtIndex:[indexPath row]] description]];
	} else { // Otherwise, if we are editing we have one extra row...
		[[cell textLabel] setText:@"Add New WOD..."];
	}
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath * )indexPath
{
	NSLog(@"Tapping...\n");
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
	[wodlist release];
    [super dealloc];
}


@end
