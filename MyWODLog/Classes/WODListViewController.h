//
//  WODListViewController.h
//  MyWODLog
//
//  Created by Derek on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CreateWODViewController.h"
#import "ViewWODViewController.h"



@interface WODListViewController : UITableViewController <NSFetchedResultsControllerDelegate, CreateWODViewControllerDelegate> {

	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectContext *addingManagedObjectContext;
	
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;


- (IBAction)createWOD;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end
