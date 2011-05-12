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

@protocol LogScoreViewControllerDelegate;

@interface LogScoreViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
	id <LogScoreViewControllerDelegate> delegate;
	WOD *wod;
	NSDate *date, *start_date;
	int hours, minutes, seconds;
	NSTimeInterval time_in_seconds;
	NSString *logNotes;
	
	// UI Elements:
	UIBarButtonItem *saveButton;
	UIDatePicker	*datePicker;
	
	IBOutlet UIPickerView	*timePicker;
	IBOutlet UIButton		*timeButton;
	IBOutlet UIButton		*hiddenButton;
	IBOutlet UITextField	*scoreField;
	IBOutlet UILabel		*scoreLabel;
	IBOutlet UITextField	*dateField;
	IBOutlet UIView			*pickerView;
	IBOutlet UIButton		*notesButton;
}

@property (nonatomic, assign) id <LogScoreViewControllerDelegate> delegate;
@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *start_date;
@property (nonatomic, retain) NSString *logNotes;

@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *timePicker;
@property (nonatomic, retain) IBOutlet UIView *pickerView;

@property (nonatomic, assign) NSTimeInterval time_in_seconds;
@property (nonatomic, assign) int hours;
@property (nonatomic, assign) int minutes;
@property (nonatomic, assign) int seconds;

@property (nonatomic, retain) IBOutlet UIButton	*timeButton;
@property (nonatomic, retain) IBOutlet UIButton	*hiddenButton;
@property (nonatomic, retain) IBOutlet UITextField	*scoreField;
@property (nonatomic, retain) IBOutlet UILabel	*scoreLabel;
@property (nonatomic, retain) IBOutlet UITextField	*dateField;
@property (nonatomic, retain) IBOutlet UIButton	*notesButton;

- (IBAction)notesButtonPressed;
- (IBAction)timeButtonPressed;
- (IBAction)save:(id)sender;
- (IBAction)scoreFieldTouched;
- (IBAction)hiddenButtonTouched;
- (IBAction)dateFieldTouched;
- (UIView *)labelCellWithWidth:(CGFloat)width rightOffset:(CGFloat)offset;

@end

@protocol LogScoreViewControllerDelegate
- (void)logScoreViewController:(LogScoreViewController *)controller didFinishWithSave:(BOOL)save;
@end