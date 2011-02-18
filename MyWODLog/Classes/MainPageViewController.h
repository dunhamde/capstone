//
//  MainPageViewController.h
//  MyWODLog
//
//  Created by Derek on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WODListViewController.h"
#import "CreateWODViewController.h"
#import "ScoresViewController.h"



@interface MainPageViewController : UIViewController {
	
	NSManagedObjectContext *managedObjectContext;	 

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    


- (IBAction)wodListPressed;
- (IBAction)scoresPressed;

@end
