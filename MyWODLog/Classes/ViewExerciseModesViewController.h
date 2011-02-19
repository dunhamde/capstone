//
//  AddExerciseViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewExerciseModesViewController : UITableViewController <UITableViewDelegate> {
	
	NSFetchedResultsController	*fetchedResultsController;
	NSManagedObjectContext		*managedObjectContext;
	NSManagedObjectContext		*addingManagedObjectContext;

}


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setLeftBarButton:(Boolean)animated;

- (IBAction)cancel:(id)sender;

// This is for creating a new exercise category/type
- (IBAction)createExerciseMode:(id)sender;

@end

