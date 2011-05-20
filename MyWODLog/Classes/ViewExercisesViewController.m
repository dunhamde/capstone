//
//  ViewExercisesViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewExercisesViewController.h"
#import "CreateWODViewController.h"


@implementation ViewExercisesViewController


@synthesize	mode, lastExerciseAdded, fetchedResultsController, managedObjectContext, cevc, quantify;


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
	
	//[self setQuantify:NO];

	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];

	if (self.mode != NULL) {
		[self setTitle:[mode name]];
	}

	// Perform Fetch of WODs
	NSError *error;
	//if (fetchedResultsController != NULL && ![[self fetchedResultsController] performFetch:&error]) {
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

	[self setCevc:nil];
	
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	//return 1;
	return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
/*	if (mode != NULL && [mode exercises] != NULL) {
		NSLog(@"RETURNING %d", [[mode exercises] count]);
		return [[mode exercises] count];
	}
	if (mode == NULL) {
		NSLog( @"MODE == NULL" );
	} else if ([mode exercises] == NULL) {
		NSLog(@"MODE EXERCISES == NULL");
	}
	NSLog(@"RETURNING ZERO");
	return 0;
*/
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



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the book's title
//	EXERCISE *exercise = [[mode exercises] anyObject];
	EXERCISE *exercise = [fetchedResultsController objectAtIndexPath:indexPath];
	if (exercise) {
		[[cell textLabel] setText:[[exercise name] capitalizedString]];
//		cell.textLabel.text = [exercise name];
		//[[cell textLabel] setText:[exercise name]];
	} else {
		NSLog( @"Exercise is NULL for a cell at row %d", [indexPath row] );
	}
	
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	BOOL canDelete = NO;
	
	EXERCISE *e = (EXERCISE*)[fetchedResultsController objectAtIndexPath:indexPath];
	
	if ([[e eexercises] count] == 0) {
		canDelete = YES;
	}
	
    return canDelete;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if( editingStyle == UITableViewCellEditingStyleDelete ) {
		
		BOOL canDelete = NO;
		
		EXERCISE *e = (EXERCISE*)[fetchedResultsController objectAtIndexPath:indexPath];
		
		if ([[e eexercises] count] == 0) {
			canDelete = YES;
		}
		
		
		if( canDelete ) {
		
			// Delete the managed object.
			NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
			[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
			
			NSError *error;
			if (![context save:&error]) {
				// Update to handle the error appropriately.
				NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
				exit(-1);  // Fail
			}
			
		} else {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to delete"
															message:@"This exercise is in use by at least one WOD."
														   delegate:nil
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			alert = nil;
			
		}

		
	} // end if( editingStyle ... )
	
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	
	[[self navigationItem] setHidesBackButton:editing animated:YES];
	
	if (editing) {
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createExercise)];
		[self.navigationItem setLeftBarButtonItem:addButton animated:animated];
		[addButton release];
	}
	else {
		[self.navigationItem setLeftBarButtonItem:nil animated:NO];
		
	}	
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



#pragma mark -
#pragma mark Adding an Exercise



/**
 Creates a new book, an AddViewController to manage addition of the book, and a new managed object context
  for the add controller to keep changes made to the book discrete from the application's managed object
  context until the book is saved.
 IMPORTANT: It's not necessary to use a second context for this. You could just use the existing context,
  which would simplify some of the code -- you wouldn't need to merge changes after a save, for example.
  This implementation, though, illustrates a pattern that may sometimes be useful (where you want to
  maintain a separate set of edits).  The root view controller sets itself as the delegate of the add
  controller so that it can be informed when the user has completed the add operation -- either saving or
  canceling (see addViewController:didFinishWithSave:).
 */
- (IBAction)createExercise {
	
    CreateExerciseViewController *createExerciseViewController = [[CreateExerciseViewController alloc] init];
	[createExerciseViewController setDelegate:self];
	
	[self setCevc:createExerciseViewController];

	
	/*
	// Create a new managed object context for the new book -- set its persistent store coordinator to the same as that from the fetched results controller's context.
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	[self setAddingManagedObjectContext:addingContext];
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
	
	createExerciseViewController.exercise = (EXERCISE *)[NSEntityDescription insertNewObjectForEntityForName:@"exercise" inManagedObjectContext:addingContext];

	[self setLastExerciseAdded:createExerciseViewController.exercise];
	 */
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createExerciseViewController];
	
    [[self navigationController] presentModalViewController:navController animated:YES];
	
	[createExerciseViewController release];
	[navController release];
}



- (void)createExerciseViewController:(CreateExerciseViewController *)controller didFinishWithSave:(BOOL)save
{

	if (save) {

		EXERCISE *e = (EXERCISE *)[NSEntityDescription insertNewObjectForEntityForName:@"exercise" inManagedObjectContext:managedObjectContext];
		
		[e setName:[[[self cevc] name] uppercaseString]];
		[e setModes:[self mode]];

		NSNumber* quant = [[NSNumber alloc] initWithBool:[[[self cevc] quantifiable] isOn]];
		NSNumber* metri = [[NSNumber alloc] initWithBool:[[[self cevc] metricRequired] isOn]];
		
		[e setQuantifiable:quant];
		[e setRequiresMetric:metri];

		[[self mode] addExercisesObject:e];
	

		NSError *error;

		if (![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}

	}


	// Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
	
}


/**
 Notification from the add controller's context's save operation
 This is used to update the fetched results controller's managed
 object context with the new book instead of performing a fetch
 (which would be a much more computationally expensive operation).
 */
- (void)createExerciseControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];
	
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"exercise" inManagedObjectContext:managedObjectContext];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"modes.name == %@",[[self mode] name]];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:pred];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	//NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Root"];
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:nil];

	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
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



#pragma mark -
#pragma mark Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	EXERCISE *e = [fetchedResultsController objectAtIndexPath:indexPath];
	
	if ([self quantify] && [[e quantifiable] boolValue] || [[e requiresMetric] boolValue] ) {
		
	
		SetExerciseQuantityViewController *seqvc = [[SetExerciseQuantityViewController alloc] init];
		[seqvc setExercise:e];
		[seqvc setGetMetric:NO];
		[seqvc setGetQuantity:NO];
		
		if ([[e requiresMetric] boolValue]) {
			[seqvc setGetMetric:YES];
		}
		
		if ([[e quantifiable] boolValue]) {
			[seqvc setGetQuantity:YES];
		}
	
		[[self navigationController] pushViewController:seqvc animated:YES];
	
		[seqvc release];
		
	} else {
	

		//NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray initWithObjects:e,nil] forKeys:[NSArray initWithObjects:@"Exericse",@"Quantity",nil]];
		NSDictionary *dict = [NSDictionary dictionaryWithObject:e forKey:@"Exercise"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ExerciseSelected" object:nil userInfo:dict];
		
		[[self navigationController] popToRootViewControllerAnimated:YES];
		
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
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end

