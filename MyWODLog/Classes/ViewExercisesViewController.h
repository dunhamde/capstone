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
#import "SetExerciseQuantityViewController.h"



@interface ViewExercisesViewController : UITableViewController <UITableViewDelegate, NSFetchedResultsControllerDelegate, CreateExerciseViewControllerDelegate> {
		
	NSFetchedResultsController	*fetchedResultsController;
	NSManagedObjectContext		*managedObjectContext;
	
	CreateExerciseViewController *cevc;
	
	MODE *mode;
	
	EXERCISE *lastExerciseAdded;

	BOOL quantify;
	
}

- (IBAction)createExercise;

@property (nonatomic, retain) MODE *mode;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) EXERCISE *lastExerciseAdded;
@property (nonatomic, retain) CreateExerciseViewController *cevc;
@property (nonatomic, assign) BOOL quantify;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)createExerciseViewController:(CreateExerciseViewController *)controller didFinishWithSave:(BOOL)save;

@end


