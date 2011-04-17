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
#import "SelectWODTypeViewController.h"


#define SECTION_DETAILS				0
#define SECTION_EXERCISES			1
#define SECTION_NOTES				2
#define SECTION_TITLE_DETAILS		@"Details"
#define SECTION_TITLE_EXERCISE		@"Exercises"
#define SECTION_TITLE_NOTES			@"Notes"



@protocol CreateWODViewControllerDelegate;


@interface CreateWODViewController : UIViewController  <UITextFieldDelegate,UITableViewDelegate> {
	
	id <CreateWODViewControllerDelegate> delegate;
	NSManagedObjectContext *managedObjectContext;
	
	UIBarButtonItem *saveButton;
	UISwitch *switchButton;

	IBOutlet UISwitch *scoreSwitch;
	IBOutlet UITableView *table;
	
	// WOD Attributes:
	NSMutableArray*	wodExerciseArray;
	NSString*		wodName;
	int				wodType;
	NSString*		wodNotes;
	
	
	BOOL readyToSave;

}

@property (nonatomic, assign) id <CreateWODViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL				readyToSave;
@property (nonatomic, retain) NSMutableArray*	wodExerciseArray;
@property (nonatomic, retain) NSString*			wodName;
@property (nonatomic, assign) int				wodType;
@property (nonatomic, retain) NSString*			wodNotes;


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    

@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
//@property (nonatomic, retain) UISwitch *switchButton;


// Notifications:
- (void)exerciseSelectedNote:(NSNotification*)saveNotification;
- (void)nameChangedNote:(NSNotification*)saveNotification;
- (void)notesChangedNote:(NSNotification*)saveNotification;
- (void)typeChangedNote:(NSNotification*)saveNotification;

// Misc Methods:

- (void)evaluateSaveReadiness;

- (IBAction)addExercise;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
//- (IBAction)startEditingMode;

//Added this line below to get rid of the warning... if the warning still exists then this line is useless
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end



@protocol CreateWODViewControllerDelegate
- (void)createWODViewController:(CreateWODViewController *)controller didFinishWithSave:(BOOL)save;
@end