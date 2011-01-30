//
//  WODListViewController.h
//  MyWODLog
//
//  Created by Derek on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewWODViewController.h"

@interface WODListViewController : UITableViewController {

	NSMutableArray *wodList;
	ViewWODViewController *vwvc;
	
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) NSMutableArray *wodList;	

- (IBAction)createWOD;

@end
