//
//  AddExerciseViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CreateExerciseModeViewController.h"
#import "ViewExercisesViewController.h"


//TODO:  Make CreateWODViewController the delegate for this

@interface ViewExerciseModesViewController : UITableViewController <UITableViewDelegate, NSFetchedResultsControllerDelegate, CreateExerciseModeViewControllerDelegate> {
	
	NSFetchedResultsController	*fetchedResultsController;
	NSManagedObjectContext		*managedObjectContext;
	NSManagedObjectContext		*addingManagedObjectContext;
	
}


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setLeftBarButton:(Boolean)animated;
- (void)createExerciseModeViewController:(CreateExerciseModeViewController *)controller didFinishWithSave:(BOOL)save;

- (void)cancel:(id)sender;

// This is for creating a new exercise category/type  (Executes when the edit button is pressed)
- (void)createExerciseMode:(id)sender;

@end
