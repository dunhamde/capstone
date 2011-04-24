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
#import	"EditViewController.h"
#import "ListEditViewController.h"


#define CW_SECTION_DETAILS				0
#define CW_SECTION_EXERCISES			1
#define CW_SECTION_NOTES				2
#define CW_SECTION_TITLE_DETAILS		@"Details"
#define CW_SECTION_TITLE_EXERCISES		@"Exercises"
#define CW_SECTION_TITLE_NOTES			@"Notes"

#define CW_NUM_SECTIONS					3



@protocol CreateWODViewControllerDelegate;


@interface CreateWODViewController : UIViewController  <UITextFieldDelegate,UITableViewDelegate> {
	
	id <CreateWODViewControllerDelegate> delegate;
	NSManagedObjectContext *managedObjectContext;
	
	// UI Elements:
	UIBarButtonItem *saveButton;

	IBOutlet UISwitch *scoreSwitch;
	IBOutlet UITableView *table;
	
	// WOD Attributes:
	NSMutableArray*	wodExerciseArray;
	NSMutableArray*	wodExerciseQtyArray;
	NSString*		wodName;
	int				wodType;
	NSString*		wodNotes;
	NSString*		wodTimeLimit;
	NSString*		wodNumRounds;
	NSMutableArray*	wodRepRounds;
	int				wodScoreType;
	
	ListEditViewController* repRoundList;
	
	// Flags:
	BOOL readyToSave;
	
	BOOL quantifyExercises;
	BOOL showTimeLimit;
	BOOL showNumRounds;
	BOOL showRepRounds;

}

@property (nonatomic, assign) id <CreateWODViewControllerDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UITableView *table;


@property (nonatomic, retain) NSMutableArray*	wodExerciseArray;
@property (nonatomic, retain) NSMutableArray*	wodExerciseQtyArray;
@property (nonatomic, retain) NSString*			wodName;
@property (nonatomic, assign) int				wodType;
@property (nonatomic, retain) NSString*			wodNotes;
@property (nonatomic, retain) NSString*			wodTimeLimit;
@property (nonatomic, retain) NSString*			wodNumRounds;
@property (nonatomic, retain) NSMutableArray*	wodRepRounds;
@property (nonatomic, assign) int				wodScoreType;

@property (nonatomic, retain) ListEditViewController* repRoundList;

@property (nonatomic, assign) BOOL				readyToSave;
@property (nonatomic, assign) BOOL				quantifyExercises;
@property (nonatomic, assign) BOOL				showTimeLimit;
@property (nonatomic, assign) BOOL				showNumRounds;
@property (nonatomic, assign) BOOL				showRepRounds;


// Notifications:
- (void)exerciseSelectedNote:(NSNotification*)saveNotification;
- (void)nameChangedNote:(NSNotification*)saveNotification;
- (void)notesChangedNote:(NSNotification*)saveNotification;
- (void)typeChangedNote:(NSNotification*)saveNotification;

- (void)timeLimitChangedNote:(NSNotification*)saveNotification;
- (void)numRoundsChangedNote:(NSNotification*)saveNotification;
- (void)repRoundsChangedNote:(NSNotification*)saveNotification;

// Misc Methods:

- (void)evaluateSaveReadiness;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end



@protocol CreateWODViewControllerDelegate
- (void)createWODViewController:(CreateWODViewController *)controller didFinishWithSave:(BOOL)save;
@end