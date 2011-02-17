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

	NSManagedObject* cWOD;
	WOD *w;
}

@property (nonatomic, retain) NSManagedObject *cWOD;
@property (nonatomic, retain) WOD *w;


- (void)setCurrentWOD:(WOD *)wod;

- (IBAction)logScorePressed;

@end
