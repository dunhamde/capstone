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
#import "EXERCISE.h"


@interface ViewWODViewController : UIViewController {

	WOD *wod;
	
	IBOutlet UILabel *scoredByLabel;
	IBOutlet UILabel *exerciseListLabel;
}

@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) UILabel *scoredByLabel;
@property (nonatomic, retain) UILabel *exerciseListLabel;


- (void)setCurrentWOD:(WOD *)w;

- (IBAction)logScorePressed;

@end
