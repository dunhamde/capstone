//
//  WODListViewController.m
//  MyWODLog
//
//  Created by Derek on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WODListViewController.h"


@implementation WODListViewController

@synthesize fetchedResultsController, managedObjectContext, createWODViewController;



- (void)viewDidLoad {
    [super viewDidLoad];
		
	// Set the nav bar to have the pre-fab'ed Edit button when
	// WODListViewController is on top of the stack
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	// Set the title of the nav bar to WOD List when WODListViewController
	// is on top of the stack
	[self setTitle:@"WOD List"];
	
	// Perform Fetch of WODs
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}
	
	

- (void)viewWillAppear {
	
	[[self tableView] reloadData];
	
}



- (void)viewDidUnload {
	
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	[self setFetchedResultsController:nil];
	
}



#pragma mark -
#pragma mark Table view data source methods

/*
 The data source methods are handled primarily by the fetch results controller
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//NSLog( @"NUM OF SECTIONS = %d", [[fetchedResultsController sections] count] );
    return [[fetchedResultsController sections] count];
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
//	NSLog( @"WOD LIST NUM OF OBJECTS = %d", [sectionInfo numberOfObjects] );
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
	[[cell textLabel] setText:[wod name]];
//	cell.textLabel.text = wod.name;
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
#pragma mark Adding a WOD

/**
 Creates a new book, an AddViewController to manage addition of the book, and a new managed object context for the add controller to keep changes made to the book discrete from the application's managed object context until the book is saved.
 IMPORTANT: It's not necessary to use a second context for this. You could just use the existing context, which would simplify some of the code -- you wouldn't need to merge changes after a save, for example. This implementation, though, illustrates a pattern that may sometimes be useful (where you want to maintain a separate set of edits).  The root view controller sets itself as the delegate of the add controller so that it can be informed when the user has completed the add operation -- either saving or canceling (see addViewController:didFinishWithSave:).
 */
- (void)createWOD {

//	self.createWODViewController = [[CreateWODViewController alloc] init];
	[self setCreateWODViewController:[[CreateWODViewController alloc] init]];

	[createWODViewController setDelegate:self];
	[createWODViewController setManagedObjectContext:[self managedObjectContext]];
		
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createWODViewController];
	
    [[self navigationController] presentModalViewController:navController animated:YES];
	
	[navController release];
}



/**
 create WOD controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)createWODViewController:(CreateWODViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
		
		// Create a new WOD in the database with specific attributes:
		WOD* wod = (WOD *)[NSEntityDescription insertNewObjectForEntityForName:@"wod" inManagedObjectContext:managedObjectContext];

		NSSet* set = [[NSSet alloc] initWithArray:[createWODViewController wodExerciseArray]];
		[wod setExercises:set];
		[wod setName:[createWODViewController wodName]];
		[wod setScore_type:[NSNumber numberWithInt:[createWODViewController wodType]]];
		[wod setNotes:[createWODViewController wodNotes]];
		
		// Save the new WOD:
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(createWODControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
		[set release];
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
	}

	// Clean up
	[createWODViewController release];
	[self setCreateWODViewController:nil];

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
#pragma mark Selecting a WOD



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)ip 
{
	//Throw a wod up
	
	ViewWODViewController *wod_view = [[ViewWODViewController alloc] init];

	WOD *wod = [fetchedResultsController objectAtIndexPath:ip];
	[wod_view setCurrentWOD:wod];
	
	//TODO: Fix crash when no exercises!
	[wod_view setWodExerciseArray:[[wod exercises] allObjects]];
	
	// Set Back Button:
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"WODs" style:UIBarButtonItemStylePlain target:nil action:nil];
	[[self navigationItem] setBackBarButtonItem:backButton];
	[backButton release];

	[[self navigationController] pushViewController:wod_view animated:YES];
	[wod_view release];

}



#pragma mark -
#pragma mark Fetched results controller



/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
	// Do not use [self fetchedResultsController] or self.fetchedResultsController (stack overflow)
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the 'wod' entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"wod" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Root"];
	[self setFetchedResultsController:aFetchedResultsController];
//	self.fetchedResultsController = aFetchedResultsController;
	[[self fetchedResultsController] setDelegate:self];
//	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	
	return fetchedResultsController;
}    



/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[[self tableView] beginUpdates];
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = [self tableView];
	
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
			[[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[[self tableView] endUpdates];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}



@end
