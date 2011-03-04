//
//  CreateWODViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOD.h"
#import "ViewExerciseModesViewController.h"

@protocol CreateWODViewControllerDelegate;


@interface CreateWODViewController : UIViewController  <UITextFieldDelegate,UITableViewDelegate, ViewExercisesViewControllerDelegate> {
	
	id <CreateWODViewControllerDelegate> delegate;
	NSManagedObjectContext *managedObjectContext;
	WOD *wod;
	
	UIBarButtonItem *saveButton;
	
	IBOutlet UITextField *name;
	IBOutlet UISwitch *scoreSwitch;
	IBOutlet UITableView *table;
	
	NSMutableArray *exerciseArray;
	
	BOOL isEditing;
}

@property (nonatomic, assign) id <CreateWODViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) NSMutableArray *exerciseArray;
@property (nonatomic, retain) IBOutlet UITableView *table;


+ (id)sharedInstance;

- (IBAction)addExercise;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)startEditingMode;

//Added this line below to get rid of the warning... if the warning still exists then this line is useless
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end



@protocol CreateWODViewControllerDelegate
- (void)createWODViewController:(CreateWODViewController *)controller didFinishWithSave:(BOOL)save;
@end