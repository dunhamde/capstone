//
//  ScoresViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewScoresViewController.h"


@interface ScoresViewController : UIViewController {
	
	ViewScoresViewController *viewscores;
	
}


- (IBAction)buttonPressed:(UIButton *)sender;

@end
