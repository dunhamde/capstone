//
//  ViewWODViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LogScoreViewController.h"
#import "WOD.h"


@interface ViewWODViewController : UIViewController {
	
	LogScoreViewController* logScore;

	WOD *wod;
}

@property (nonatomic, retain) WOD *wod;


- (void)setCurrentWOD:(WOD *)w;

- (IBAction)logScorePressed;

@end
