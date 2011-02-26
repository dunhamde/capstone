//
//  CreateExerciseViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EXERCISE.h"


@protocol CreateExerciseViewControllerDelegate;


@interface CreateExerciseViewController : UIViewController {
	
	id <CreateExerciseViewControllerDelegate> delegate;
	
	EXERCISE *exercise;
	
	IBOutlet UITextField *nameField;
	
	NSString *name;
	
}


- (void)cancel:(id)sender;
- (void)save:(id)sender;

@property (nonatomic, assign) id <CreateExerciseViewControllerDelegate> delegate;
@property (nonatomic, retain) EXERCISE *exercise;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) NSString *name;

@end



@protocol CreateExerciseViewControllerDelegate
- (void)createExerciseViewController:(CreateExerciseViewController *)controller didFinishWithSave:(BOOL)save;
@end