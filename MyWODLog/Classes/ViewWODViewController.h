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

	WOD							*wod;
	LogScoreViewController		*logScoreViewController;
	NSManagedObjectContext		*managedObjectContext;
	NSFetchedResultsController	*fetchedResultsController;
		
	// UI Elements:
	IBOutlet UILabel			*scoredByLabel;
	IBOutlet UITableView		*table;
	UIBarButtonItem				*logButton;
	UIView						*notesView;
	UILabel						*notesTitleLabel;
	UITextView					*notesTextView;
	
	// Flags:
	BOOL showTimeLimit;
	BOOL showNumRounds;
	BOOL showRepRounds;
	
}

@property (nonatomic, retain) WOD							*wod;
@property (nonatomic, retain) LogScoreViewController		*logScoreViewController;
@property (nonatomic, retain) NSManagedObjectContext		*managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController	*fetchedResultsController;

@property (nonatomic, retain) UIBarButtonItem				*logButton;
@property (nonatomic, retain) IBOutlet UITableView			*table;
@property (nonatomic, retain) UILabel						*scoredByLabel;
@property (nonatomic, retain) UIView						*notesView;
@property (nonatomic, retain) UILabel						*notesTitleLabel;
@property (nonatomic, retain) UITextView					*notesTextView;

@property (nonatomic, assign) BOOL							showTimeLimit;
@property (nonatomic, assign) BOOL							showNumRounds;
@property (nonatomic, assign) BOOL							showRepRounds;

- (void)setCurrentWOD:(WOD *)w;
- (IBAction)logScorePressed:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)notesViewTouched:(UITapGestureRecognizer *)recognizer;



@end
