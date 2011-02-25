//
//  CreateExerciseModeViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MODE.h"


@protocol CreateExerciseModeViewControllerDelegate;


@interface CreateExerciseModeViewController : UIViewController <UITextFieldDelegate> {
	
	MODE* mode;
	
	UIBarButtonItem *saveButton;
	
	IBOutlet UITextField *nameField;
	
	NSString *name;
	
	id <CreateExerciseModeViewControllerDelegate> delegate;

}


- (void)cancel:(id)sender;
- (void)save:(id)sender;


@property (nonatomic, retain) MODE *mode;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) id <CreateExerciseModeViewControllerDelegate> delegate;

@end


@protocol CreateExerciseModeViewControllerDelegate
- (void)createExerciseModeViewController:(CreateExerciseModeViewController *)controller didFinishWithSave:(BOOL)save;
@end