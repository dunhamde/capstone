//
//  ViewExercisesViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODE.h"
#import "CreateExerciseViewController.h"


@interface ViewExercisesViewController : UITableViewController <UITableViewDelegate, NSFetchedResultsControllerDelegate, CreateExerciseViewControllerDelegate> {
	
	NSFetchedResultsController	*fetchedResultsController;
	NSManagedObjectContext		*managedObjectContext;
	NSManagedObjectContext		*addingManagedObjectContext;
	
	MODE *mode;

}

- (IBAction)createExercise;


@property (nonatomic, retain) MODE *mode;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)createExerciseViewController:(CreateExerciseViewController *)controller didFinishWithSave:(BOOL)save;

@end
