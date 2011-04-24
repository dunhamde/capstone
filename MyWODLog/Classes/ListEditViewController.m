//
//  ListEditViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListEditViewController.h"


@implementation ListEditViewController

@synthesize titleName, notificationName, elements, addTitleName;

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
	
}



- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
	
	
	// Set up notifications
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(elementAddedNote:) name:@"ElementSent" object:nil];
	
}


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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
	//	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	//	[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
	//	NSError *error;
	//	if (![context save:&error]) {
			// Update to handle the error appropriately.
	//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	//		exit(-1);  // Fail
	//	}
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
    [super setEditing:editing animated:animated];
	
	[[self navigationItem] setHidesBackButton:editing animated:YES];
	
	if (editing) {
		
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addElement)];
		[[self navigationItem] setLeftBarButtonItem:addButton animated:animated];
		[addButton release];
		
	}
	else {
		
		[[self navigationItem] setLeftBarButtonItem:nil animated:NO];
		
	}
	
}



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

	if (num != nil) {
		[[self elements] addObject:num];
		[[self tableView] reloadData];
	}
	
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"ElementSent" object:nil];
	
}

#pragma mark -
#pragma mark Save/Cancel Buttons
						   


- (void)addElement {
	
	EditViewController *controller = [[EditViewController alloc] init];
	
	[controller setTitleName:[self addTitleName]];
	[controller setNotificationName:@"ElementSent"];
	[controller setEditType:EDIT_TYPE_NUMBER];
	[controller setPopToRoot:NO];
	
	[[self navigationController] pushViewController:controller animated:YES];		
	
	[controller release];
	
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

