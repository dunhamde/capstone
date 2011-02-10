//
//  CreateWODViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOD.h"

@protocol CreateWODViewControllerDelegate;


@interface CreateWODViewController : UIViewController  <UITextFieldDelegate,UITableViewDelegate> {
	
	id <CreateWODViewControllerDelegate> delegate;
	NSManagedObjectContext *managedObjectContext;
	WOD *wod;
	
	UIBarButtonItem *saveButton;
	
	IBOutlet UITextField *name;
	IBOutlet UISwitch *scoreSwitch;
	
	BOOL isEditing;
}

@property (nonatomic, assign) id <CreateWODViewControllerDelegate> delegate;
@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, retain) UIBarButtonItem *saveButton;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)startEditingMode;

@end

@protocol CreateWODViewControllerDelegate
- (void)createWODViewController:(CreateWODViewController *)controller didFinishWithSave:(BOOL)save;
@end