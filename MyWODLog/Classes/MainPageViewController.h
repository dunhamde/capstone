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
	
//	WODListViewController *wlvc;
//	CreateWODViewController *createWOD;
//	ScoresViewController *scores;
	
	NSManagedObjectContext *managedObjectContext;	 

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    

	
//- (IBAction)buttonPressed:(UIButton *)sender;
- (IBAction)wodListPressed;
- (IBAction)scoresPressed;

@end
