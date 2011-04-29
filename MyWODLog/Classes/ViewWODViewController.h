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
#import "EXERCISE.h"

#define VW_SECTION_DETAILS				0
#define VW_SECTION_EXERCISES			1
#define VW_SECTION_NOTES				2
#define VW_SECTION_TITLE_DETAILS		@"Details"
#define VW_SECTION_TITLE_EXERCISES		@"Exercises"
#define VW_SECTION_TITLE_NOTES			@"Notes"

#define VW_NUM_SECTIONS					3

@interface ViewWODViewController : UIViewController <UITableViewDelegate, LogScoreViewControllerDelegate> {

	WOD						*wod;
	LogScoreViewController	*logScoreViewController;
	NSManagedObjectContext  *managedObjectContext;
	NSFetchedResultsController	*fetchedResultsController;
	
	//IBOutlet UILabel *exerciseListLabel;
	IBOutlet UILabel		*scoredByLabel;
	IBOutlet UITableView	*table;
	
	// UI Elements:
	UIBarButtonItem			*logButton;
	
	// WOD Attributes:
	NSArray*				wodExerciseArray;
	NSString*				wodName;
	int						wodType;
	NSString*				wodNotes;
	NSString*				wodTimeLimit;
	NSString*				wodNumRounds;
	NSMutableArray*			wodRepRounds;
	int						wodScoreType;
	
	// Flags:
	
	BOOL showTimeLimit;
	BOOL showNumRounds;
	BOOL showRepRounds;
}

@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) LogScoreViewController *logScoreViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) UILabel *scoredByLabel;
//@property (nonatomic, retain) UILabel *exerciseListLabel;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) UIBarButtonItem *logButton;

@property (nonatomic, assign) BOOL				showTimeLimit;
@property (nonatomic, assign) BOOL				showNumRounds;
@property (nonatomic, assign) BOOL				showRepRounds;


@property (nonatomic, retain) NSArray*	wodExerciseArray;
@property (nonatomic, retain) NSString*			wodName;
@property (nonatomic, assign) int				wodType;
@property (nonatomic, retain) NSString*			wodNotes;
@property (nonatomic, retain) NSString*			wodTimeLimit;
@property (nonatomic, retain) NSString*			wodNumRounds;
@property (nonatomic, retain) NSMutableArray*	wodRepRounds;
@property (nonatomic, assign) int				wodScoreType;

- (void)setCurrentWOD:(WOD *)w;

- (IBAction)logScorePressed:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
