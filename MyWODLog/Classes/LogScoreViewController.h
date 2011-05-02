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

@interface LogScoreViewController : UIViewController {
	
	id <LogScoreViewControllerDelegate> delegate;
	WOD *wod;
	NSDate *date, *start_date;
	int hours, minutes, seconds;
	NSTimeInterval time_in_seconds;
	
	// UI Elements:
	UIBarButtonItem *saveButton;
	
	IBOutlet UIButton		*timeButton;	
	IBOutlet UITextField	*timeField;
	IBOutlet UITextField	*repsField;	
	IBOutlet UILabel		*timeLabel;
	IBOutlet UILabel		*repsLabel;
	IBOutlet UITextField	*dateField;
}

@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *start_date;

@property (nonatomic, retain) UIBarButtonItem *saveButton;

@property (nonatomic, assign) NSTimeInterval time_in_seconds;
@property (nonatomic, assign) int hours;
@property (nonatomic, assign) int minutes;
@property (nonatomic, assign) int seconds;

@property (nonatomic, retain) IBOutlet UIButton	*timeButton;
@property (nonatomic, retain) IBOutlet UITextField	*timeField;
@property (nonatomic, retain) IBOutlet UITextField	*repsField;
@property (nonatomic, retain) IBOutlet UILabel	*timeLabel;
@property (nonatomic, retain) IBOutlet UILabel	*repsLabel;
@property (nonatomic, retain) IBOutlet UITextField	*dateField;

- (IBAction)timeButtonPressed;
- (IBAction)save:(id)sender;

@end

@protocol LogScoreViewControllerDelegate
- (void)logScoreViewController:(LogScoreViewController *)controller didFinishWithSave:(BOOL)save;
@end