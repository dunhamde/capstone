//
//  ViewScoresViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CHCSVWriter.h"

#define DATE_INDEX 0
#define WOD_INDEX 1

@interface ViewScoresViewController : UIViewController <UITableViewDelegate, NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate> {
	
	//UIToolbar *toolbar;
	IBOutlet UITableView		*table;
	NSFetchedResultsController	*fetchedResultsController;
	NSManagedObjectContext		*managedObjectContext;
	NSArray						*curScores;
	IBOutlet UILabel			*filterLabel;
	IBOutlet UISegmentedControl	*segmentedControl;
	NSUInteger					selectedUnit;
	
	UIView						*notesView;
	UILabel						*notesTitleLabel;
	UITextView					*notesTextView;

}



- (void)notesViewTouched:(UITapGestureRecognizer *)recognizer;
- (IBAction)toggleSort;
- (IBAction)exportPressed:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)exportAllData;



@property (nonatomic, retain) UITableView					*table;
@property (nonatomic, retain) NSFetchedResultsController	*fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext		*managedObjectContext;
@property (nonatomic, retain) IBOutlet UILabel				*filterLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl	*segmentedControl;
@property (nonatomic, retain) NSArray						*curScores;

@property (nonatomic, retain) UIView						*notesView;
@property (nonatomic, retain) UILabel						*notesTitleLabel;
@property (nonatomic, retain) UITextView					*notesTextView;



@end
