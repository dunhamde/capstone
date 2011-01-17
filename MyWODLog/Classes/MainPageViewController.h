//
//  MainPageViewController.h
//  MyWODLog
//
//  Created by Derek on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WODListViewController.h"

@interface MainPageViewController : UIViewController {
	
	IBOutlet UILabel *testLabel;
	WODListViewController *wlvc;

}

@property (nonatomic, retain) IBOutlet UILabel* testLabel;
	
- (IBAction)buttonPressed:(UIButton *)sender;

@end
