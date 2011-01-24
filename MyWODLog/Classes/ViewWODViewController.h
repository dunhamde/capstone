//
//  ViewWODViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogScoreViewController.h"


@interface ViewWODViewController : UIViewController {
	
	LogScoreViewController* logScore;

}

- (IBAction)logScorePressed;

@end
