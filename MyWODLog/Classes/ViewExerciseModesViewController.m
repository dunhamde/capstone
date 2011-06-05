//
//  AddExerciseViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewExerciseModesViewController.h"
#import "CreateWODViewController.h"


@implementation ViewExerciseModesViewController

@synthesize fetchedResultsController, managedObjectContext, addingManagedObjectContext, quantify;



#pragma mark -
#pragma mark View lifecycle



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		[self setQuantify:NO];
    }
    return self;
}



- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self setTitle:@"Categories"];
	
	
	// Configure the save and cancel buttons.
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[[self tableView] setAllowsSelectionDuringEditing:NO];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

}





#pragma mark -
#pragma mark Edit and cancel operations







- (void)createExerciseMode:(id)sender {
	
	CreateExerciseModeViewController *createExerciseModeViewController = [[CreateExerciseModeViewController alloc] init];
	
	[createExerciseModeViewController setDelegate:self];
	[createExerciseModeViewController setManagedObjectContext:[self managedObjectContext]];
	

	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	[self setAddingManagedObjectContext:addingContext];

	[addingContext release];
	
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];

	
	createExerciseModeViewController.mode = (MODE *)[NSEntityDescription insertNewObjectForEntityForName:@"mode" inManagedObjectContext:addingContext];


	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createExerciseModeViewController];
	
    [[self navigationController] presentModalViewController:navController animated:YES];
	
	[createExerciseModeViewController release];
	[navController release];
}



/**
 * Create Exercise Mode controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)createExerciseModeViewController:(CreateExerciseModeViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {

		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(createExerciseModeControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
	
		NSError *error;

		if (![addingManagedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}

		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];

	}
	
	// Release the adding managed object context.
	[self setAddingManagedObjectContext:nil];

	// Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
	
}



/**
 Notification from the add controller's context's save operation. This is used to update the fetched results controller's managed object context with the new book instead of performing a fetch (which would be a much more computationally expensive operation).
 */
- (void)createExerciseModeControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];
	
}




#pragma mark -
#pragma mark Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return [[fetchedResultsController sections] count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
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
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
	
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ViewExercisesViewController *viewExercisesViewController = [[ViewExercisesViewController alloc] init];
	
	MODE *m = [fetchedResultsController objectAtIndexPath:indexPath];
	
	[viewExercisesViewController setMode:m];
		
	[viewExercisesViewController setManagedObjectContext:[self managedObjectContext]];
	[viewExercisesViewController setQuantify:[self quantify]];
	[[self navigationController] pushViewController:viewExercisesViewController animated:YES];

	[viewExercisesViewController release];

}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    // Configure the cell to show the book's title
	MODE *mode = [fetchedResultsController objectAtIndexPath:indexPath];
	if (mode) {
		[[cell textLabel] setText:[[mode name] capitalizedString]];

	} else {
	}
	
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if( editingStyle == UITableViewCellEditingStyleDelete ) {
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



- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	
//	[self.navigationItem setHidesBackButton:editing animated:YES];
	[[self navigationItem] setHidesBackButton:editing animated:YES];
	
	if (editing) {
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createExerciseMode:)];
//		[self.navigationItem setLeftBarButtonItem:addButton animated:animated];
		[[self navigationItem] setLeftBarButtonItem:addButton animated:animated];
		[addButton release];
	}
	else {
		//[self.navigationItem setLeftBarButtonItem:nil animated:NO];
		[[self navigationItem] setLeftBarButtonItem:nil animated:NO];
		//[self setLeftBarButton:YES];
	}	
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
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	[self setFetchedResultsController:nil];
	//	self.fetchedResultsController = nil;
}



- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[addingManagedObjectContext release];
    [super dealloc];
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"mode" inManagedObjectContext:managedObjectContext];
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
	[sortDescriptors release];
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



@end

