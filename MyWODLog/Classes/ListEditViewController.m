//
//  ListEditViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListEditViewController.h"


@implementation ListEditViewController

@synthesize titleName, notificationName, elements;

#pragma mark -
#pragma mark View lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.elements = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
	
}



- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self setTitle:[self titleName]];
	
	
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc addObserver:self selector:@selector(elementAddedNote:) name:@"ElementSent" object:nil];
	
	
	
	// Set Save Button:
//    UIBarButtonItem *bbi;
//    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
//                                                        target:self
//                                                        action:@selector(save:)];
//    [[self navigationItem] setRightBarButtonItem:bbi];
//    [bbi release];
	
	// Set Cancel Button:
//    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                        target:self
//                                                        action:@selector(cancel:)];
//    [[self navigationItem] setLeftBarButtonItem:bbi];
 //   [bbi release];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self elements] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the book's title
	NSNumber *num = (NSNumber *)[[self elements] objectAtIndex:[indexPath row]];
	cell.textLabel.text = [num stringValue];
	
}




/*
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
	EXERCISE *exercise = (EXERCISE *)[exerciseArray objectAtIndex:indexPath.row];
	NSLog(@" EXERCISE INTO TABLE %@",exercise);
	cell.textLabel.text = [exercise name];
}

*/









/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}
						   
#pragma mark -
#pragma mark Notifications
- (void)elementAddedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'WOD Name' and refresh the table
	NSString *s = [dict objectForKey:@"Text"];
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * num = [f numberFromString:s];
	[f release];

	[[self elements] addObject:num];
	//[self setWodName:[dict objectForKey:@"Text"]];
	[[self table] reloadData];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"ElementSent" object:nil];
	
}

#pragma mark -
#pragma mark Save/Cancel Buttons
						   
- (IBAction)cancel:(id)sender
{
	[[self navigationController] popToRootViewControllerAnimated:YES];
}



- (IBAction)save:(id)sender
{
	
	// Create a dictionary with the exercise and the quantity and their respective keys
	/*NSString *returnable;
	
	if (self.editField.hidden == YES) {
		returnable = [[self editBox] text];
	}
	else {
		returnable = [[self editField] text];
	}
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:returnable,nil] forKeys:[NSArray arrayWithObjects:DICTIONARY_KEY,nil]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:[self notificationName] object:nil userInfo:dict];
	
	[[self navigationController] popToRootViewControllerAnimated:YES];*/
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

