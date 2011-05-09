//
//  LogScoreViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOD.h"

@protocol LogScoreViewControllerDelegate;

@interface LogScoreViewController : UIViewController <UITextFieldDelegate> {
	
	id <LogScoreViewControllerDelegate> delegate;
	WOD *wod;
	NSDate *date, *start_date;
	int hours, minutes, seconds;
	NSTimeInterval time_in_seconds;
	
	// UI Elements:
	UIBarButtonItem *saveButton;
	UIDatePicker	*datePicker;
	
	IBOutlet UIButton		*timeButton;
	IBOutlet UIButton		*hiddenButton;
	IBOutlet UITextField	*scoreField;
	IBOutlet UILabel		*scoreLabel;
	IBOutlet UITextField	*dateField;
}

@property (nonatomic, assign) id <LogScoreViewControllerDelegate> delegate;
@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *start_date;

@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) UIDatePicker *datePicker;

@property (nonatomic, assign) NSTimeInterval time_in_seconds;
@property (nonatomic, assign) int hours;
@property (nonatomic, assign) int minutes;
@property (nonatomic, assign) int seconds;

@property (nonatomic, retain) IBOutlet UIButton	*timeButton;
@property (nonatomic, retain) IBOutlet UIButton	*hiddenButton;
@property (nonatomic, retain) IBOutlet UITextField	*scoreField;
@property (nonatomic, retain) IBOutlet UILabel	*scoreLabel;
@property (nonatomic, retain) IBOutlet UITextField	*dateField;

- (IBAction)timeButtonPressed;
- (IBAction)save:(id)sender;
- (IBAction)scoreFieldTouched;
- (IBAction)hiddenButtonTouched;

@end

@protocol LogScoreViewControllerDelegate
- (void)logScoreViewController:(LogScoreViewController *)controller didFinishWithSave:(BOOL)save;
@end