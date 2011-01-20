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

@interface MainPageViewController : UIViewController {
	
	IBOutlet UILabel *testLabel;
	WODListViewController *wlvc;
	CreateWODViewController *createWOD;

}

@property (nonatomic, retain) IBOutlet UILabel* testLabel;
	
- (IBAction)buttonPressed:(UIButton *)sender;

@end
