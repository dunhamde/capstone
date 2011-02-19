//
//  CreateExerciseModeViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODE.h"


@interface CreateExerciseModeViewController : UIViewController <UITextFieldDelegate> {
	
	MODE* mode;
	
	UIBarButtonItem *saveButton;
	
	IBOutlet UITextField *name;

}

@property (nonatomic, retain) MODE *mode;

@end
