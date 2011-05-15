//
//  LogScoreViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOD.h"
#import "EditViewController.h"

#define MINUTES_COMPONENT 0
#define MINUTES_COMPONENT_WIDTH 110
#define MINUTES_LABEL_WIDTH 60

#define SECONDS_COMPONENT 1
#define SECONDS_COMPONENT_WIDTH 106
#define SECONDS_LABEL_WIDTH 56

// Identifies for component views
#define VIEW_TAG 41
#define SUB_LABEL_TAG 42
#define LABEL_TAG 43

// Table defines
#define LS_SECTION_DATE					0
#define LS_SECTION_SCORE				1
#define	LS_SECTION_NOTES				2
#define LS_SECTION_TITLE_DATE			@""
#define LS_SECTION_TITLE_SCORE			@"Score"
#define LS_SECTION_TITLE_NOTES			@"Notes"
#define LS_NUM_SECTIONS 3

#define LS_NUM_ROWS	3

@protocol LogScoreViewControllerDelegate;

@interface LogScoreViewController : UIViewController < UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
	IBOutlet UITableView		*table;
	
	id <LogScoreViewControllerDelegate> delegate;
	WOD *wod;
	NSDate *date, *start_date;
	int hours, minutes, seconds, scoreNum;
	NSTimeInterval time_in_seconds;
	NSString *logNotes;
	NSString *dateFormatted;
	BOOL editingDate, editingScore;
	
	// UI Elements:
	IBOutlet UIDatePicker	*datePicker;
	IBOutlet UIView			*datePickerView;
	
//	UITextField	*dateView;
	
	IBOutlet UIPickerView	*timePicker;
	IBOutlet UIButton		*timeButton;
	IBOutlet UIButton		*hiddenButton;
	IBOutlet UITextField	*scoreField;
	IBOutlet UIView			*pickerView;
}

@property (nonatomic, retain) IBOutlet UITableView			*table;

@property (nonatomic, assign) id <LogScoreViewControllerDelegate> delegate;
@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *start_date;
@property (nonatomic, retain) NSString *logNotes;
@property (nonatomic, retain) NSString *dateFormatted;
@property (nonatomic, assign) BOOL	editingDate;
@property (nonatomic, assign) BOOL	editingScore;

//@property (nonatomic, retain) UITextField	*dateView;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *timePicker;
@property (nonatomic, retain) IBOutlet UIView *pickerView;
@property (nonatomic, retain) IBOutlet UIView *datePickerView;

@property (nonatomic, assign) NSTimeInterval time_in_seconds;
@property (nonatomic, assign) int hours;
@property (nonatomic, assign) int minutes;
@property (nonatomic, assign) int seconds;
@property (nonatomic, assign) int scoreNum;

@property (nonatomic, retain) IBOutlet UIButton	*timeButton;
@property (nonatomic, retain) IBOutlet UIButton	*hiddenButton;
@property (nonatomic, retain) IBOutlet UITextField	*scoreField;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)timeButtonPressed;
- (IBAction)save:(id)sender;
- (IBAction)hiddenButtonTouched;
- (UIView *)labelCellWithWidth:(CGFloat)width rightOffset:(CGFloat)offset;

@end

@protocol LogScoreViewControllerDelegate
- (void)logScoreViewController:(LogScoreViewController *)controller didFinishWithSave:(BOOL)save;
@end