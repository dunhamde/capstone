    //
//  WODListViewController.m
//  MyWODLog
//
//  Created by Derek on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WODListViewController.h"
//#import "CreateWODViewController.h"


@implementation WODListViewController

@synthesize fetchedResultsController, managedObjectContext, addingManagedObjectContext;



- (void)viewDidLoad {
    [super viewDidLoad];
		
	// Set the nav bar to have the pre-fab'ed Edit button when
	// WODListViewController is on top of the stack
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	// Set the title of the nav bar to WOD List when WODListViewController
	// is on top of the stack
	[self setTitle:@"WOD List"];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}
	
	

- (void)viewWillAppear {
	[self.tableView reloadData];
}
- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.fetchedResultsController = nil;
}

#pragma mark -
#pragma mark Table view data source methods

/*
 The data source methods are handled primarily by the fetch results controller
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
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
	WOD *wod = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = wod.name;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }   
}

#pragma mark -
#pragma mark Selection and moving

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark -
#pragma mark Adding a Book

/**
 Creates a new book, an AddViewController to manage addition of the book, and a new managed object context for the add controller to keep changes made to the book discrete from the application's managed object context until the book is saved.
 IMPORTANT: It's not necessary to use a second context for this. You could just use the existing context, which would simplify some of the code -- you wouldn't need to merge changes after a save, for example. This implementation, though, illustrates a pattern that may sometimes be useful (where you want to maintain a separate set of edits).  The root view controller sets itself as the delegate of the add controller so that it can be informed when the user has completed the add operation -- either saving or canceling (see addViewController:didFinishWithSave:).
 */
- (IBAction)createWOD {
	
    CreateWODViewController *createWODViewController = [[CreateWODViewController alloc] init];
	createWODViewController.delegate = self;
	
	// Create a new managed object context for the new book -- set its persistent store coordinator to the same as that from the fetched results controller's context.
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
	
	createWODViewController.wod = (WOD *)[NSEntityDescription insertNewObjectForEntityForName:@"wod" inManagedObjectContext:addingContext];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createWODViewController];
	
    [self.navigationController presentModalViewController:navController animated:YES];
	
	[createWODViewController release];
	[navController release];
}


/**
 create WOD controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)createWODViewController:(CreateWODViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
		/*
		 The new book is associated with the add controller's managed object context.
		 This is good because it means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad -- but it does make it more difficult to get the new book registered with the fetched results controller.
		 First, you have to save the new book.  This means it will be added to the persistent store.  Then you can retrieve a corresponding managed object into the application delegate's context.  Normally you might do this using a fetch or using objectWithID: -- for example
		 
		 NSManagedObjectID *newBookID = [controller.book objectID];
		 NSManagedObject *newBook = [applicationContext objectWithID:newBookID];
		 
		 These techniques, though, won't update the fetch results controller, which only observes change notifications in its context.
		 You don't want to tell the fetch result controller to perform its fetch again because this is an expensive operation.
		 You can, though, update the main context using mergeChangesFromContextDidSaveNotification: which will emit change notifications that the fetch results controller will observe.
		 To do this:
		 1	Register as an observer of the add controller's change notifications
		 2	Perform the save
		 3	In the notification method (addControllerContextDidSave:), merge the changes
		 4	Unregister as an observer
		 */
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(createWODControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
		NSError *error;
		if (![addingManagedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
	}
	// Release the adding managed object context.
	self.addingManagedObjectContext = nil;
	
	// Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
}


/**
 Notification from the add controller's context's save operation. This is used to update the fetched results controller's managed object context with the new book instead of performing a fetch (which would be a much more computationally expensive operation).
 */
- (void)createWODControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
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

#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"wod" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	//NSSortDescriptor *authorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"author" ascending:YES];
	//NSSortDescriptor *titleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	//[authorDescriptor release];
	//[titleDescriptor release];
	//[sortDescriptors release];
	
	return fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.tableView;
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}
/*
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
}*/
/*
- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath * )indexPath
{
	
	if (!vwvc) {
		vwvc = [[ViewWODViewController alloc] init];
	}
	[[self navigationController] pushViewController:vwvc animated:YES];

	
}*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	//[wodList release];
	[fetchedResultsController release];
	[managedObjectContext release];
	[addingManagedObjectContext release];
    [super dealloc];
}


@end
