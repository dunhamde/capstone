//
//  LogScoreViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogScoreViewController.h"


@implementation LogScoreViewController

@synthesize delegate, wod, scoreField, scoreLabel, timeButton, hiddenButton, date, start_date, dateField, logNotes;
@synthesize time_in_seconds, hours, minutes, seconds;
@synthesize saveButton, datePicker, timePicker, pickerView, notesButton;


- (void)viewDidLoad {
	[super viewDidLoad];
	NSString *title = @"Log Score for ";
	[self setTitle:[title stringByAppendingString:[wod name]]];
	self.hiddenButton.enabled = NO;	
	
	datePicker = [[UIDatePicker alloc] init];
	dateField.inputView = datePicker; 
	
	// Configure the save button.
	[self setSaveButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)]];
	[[self saveButton] setEnabled:YES];
	[[self navigationItem] setRightBarButtonItem:[self saveButton]];
	[saveButton release];
	
	// Set dateField to current date by default
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy"];
	NSString *curDate = [format stringFromDate:[NSDate date]];
	[[self dateField] setText:curDate];
	[self setDate:[NSDate date]];

	// Configure UI elements dependent on the score type
	NSLog(@"Score Type: %@", [wod score_type]);
	switch ([[wod score_type] intValue]) {
        case WOD_SCORE_TYPE_NONE:
			self.scoreLabel.text = @"Time";
			self.scoreField.inputView = pickerView;
            break;
        case WOD_SCORE_TYPE_TIME:
			self.scoreLabel.text = @"Time";
			self.scoreField.inputView = timePicker;
            break;
		case WOD_SCORE_TYPE_REPS:
			self.scoreLabel.text = @"Reps";
			self.timeButton.hidden = YES;
			self.timeButton.enabled = NO;
			self.scoreField.keyboardType = UIKeyboardTypeNumberPad;
            break;
		case WOD_SCORE_TYPE_RNDS:
			self.scoreLabel.text = @"Rounds";
			self.timeButton.hidden = YES;
			self.timeButton.enabled = NO;
			self.scoreField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }	
	
	[format release];


}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"VIEW WILL APPEAR");
	// Register for exercises saved notifications
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc addObserver:self selector:@selector(notesChangedNote:) name:@"LogNotesSent" object:nil];

}

- (void)notesChangedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'Notes' and refresh the table
	[self setLogNotes:[dict objectForKey:@"Text"]];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@":LogNotesSent" object:nil];
}

- (void)notesButtonPressed	{
	EditViewController *controller = [[EditViewController alloc] init];
	
	[controller setTitleName:@"Log Notes"];
	[controller setNotificationName:@"LogNotesSent"];
	[controller setEditType:EDIT_TYPE_TEXTBOX];
	[controller setDefaultText:[self logNotes]];
	[controller setPopToRoot:NO];
	[[self navigationController] pushViewController:controller animated:YES];		
	
	[controller release];

}

- (void)timeButtonPressed	{
		
	if ([[[[self timeButton] titleLabel] text] isEqualToString:@"Start Timer!"]) {
		[self setStart_date:[NSDate date]];
		[timeButton setTitle:@"Stop Timer!" forState:UIControlStateNormal];
	} else {
		[self setDate:[NSDate date]];
		[self setTime_in_seconds:[date timeIntervalSinceDate:start_date]];
		// Found this next section on stackoverflow for getting minutes and seconds between two dates
		
		// Get the system calendar
		NSCalendar *sysCalendar = [NSCalendar currentCalendar];
			
		// Get conversion to hours, minutes, seconds
		unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit; 
		
		NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:[self start_date]  toDate:[self date]  options:0];
		
		NSLog(@"Conversion: %dhours %dmin %dsec",[conversionInfo hour], [conversionInfo minute], [conversionInfo second]);
		[self setHours:[conversionInfo hour]];
		[self setMinutes:[conversionInfo minute]];
		[self setSeconds:[conversionInfo second]];
		
		NSString *placeholder = [NSString stringWithFormat:@"%i:%.2i",[conversionInfo minute],[conversionInfo second]];
		[scoreField setText:placeholder];
		[timeButton setTitle:@"Start Timer!" forState:UIControlStateNormal];
	}	
}

- (void)scoreFieldTouched {

	//NSLog(@"score TOUCHED");
	[hiddenButton setUserInteractionEnabled:YES];
	self.hiddenButton.enabled = YES;
}

- (void)hiddenButtonTouched {
	
	NSLog(@"subviews %@", [timePicker subviews]);
	//NSLog(@"hidden TOUCHED");
	self.hiddenButton.enabled = NO;
	[scoreField resignFirstResponder];
	
	// Check to see if the user is trying to stop setting the date. If the hiddenButton is pressed while the Date Picker is up, close it.
	if ([dateField isFirstResponder]) {
		[dateField	resignFirstResponder];
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MM/dd/yyyy"];
		NSString *newDate = [format stringFromDate:[datePicker date]];
		[[self dateField] setText:newDate];
		[self setDate:[datePicker date]];
		[format release];
	}
	
}

- (void)dateFieldTouched {
	//NSLog(@"score TOUCHED");
	[hiddenButton setUserInteractionEnabled:YES];
	self.hiddenButton.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (IBAction)save:(id)sender	{
	NSLog(@"SAVING LOG");
	[delegate logScoreViewController:self didFinishWithSave:YES];
	[[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIPickerViewDelegate delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component	{
	NSInteger min = [timePicker selectedRowInComponent:MINUTES_COMPONENT];
	NSInteger sec = [timePicker selectedRowInComponent:SECONDS_COMPONENT];
	[self setTime_in_seconds:(sec + (min * 60))];
	[scoreField setText:[NSString stringWithFormat:@"%i:%.2i",min,sec]];
	
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	UIView *returnView = nil;
	
	// Reuse the label if possible, otherwise create and configure a new one.
	if ((view.tag == VIEW_TAG) || (view.tag == LABEL_TAG)) {
		returnView = view;
	}
	else {
        if (component == MINUTES_COMPONENT) {
            returnView = [self labelCellWithWidth:MINUTES_COMPONENT_WIDTH rightOffset:MINUTES_LABEL_WIDTH];
        }
        else {
            returnView = [self labelCellWithWidth:SECONDS_COMPONENT_WIDTH rightOffset:SECONDS_LABEL_WIDTH];
        }
	}
	
	// The text shown in the component is just the number of the component.
	NSString *text = [NSString stringWithFormat:@"%d", row];
	
	// Where to set the text in depends on what sort of view it is.
	UILabel *theLabel = nil;
	if (returnView.tag == VIEW_TAG) {
		theLabel = (UILabel *)[returnView viewWithTag:SUB_LABEL_TAG];
	}
	else {
		theLabel = (UILabel *)returnView;
	}
    
	theLabel.text = text;
	return returnView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	if (component == MINUTES_COMPONENT) {
		return MINUTES_COMPONENT_WIDTH;
	}

	return SECONDS_COMPONENT_WIDTH;
}


#pragma mark -
#pragma mark UIPickerViewDataSource delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView	{
	
	// Needs components for showing minutes and seconds
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component	{
	
	// Both minutes and seconds require 59 rows
	return 59;
}

#pragma mark -
#pragma mark Misc. methods

- (UIView *)labelCellWithWidth:(CGFloat)width rightOffset:(CGFloat)offset {
	
	// Create a new view that contains a label offset from the right.
	CGRect frame = CGRectMake(0.0, 0.0, width, 32.0);
	UIView *view = [[[UIView alloc] initWithFrame:frame] autorelease];
	view.tag = VIEW_TAG;
	
	frame.size.width = width - offset;
	UILabel *subLabel = [[UILabel alloc] initWithFrame:frame];
	subLabel.textAlignment = UITextAlignmentRight;
	subLabel.backgroundColor = [UIColor clearColor];
	subLabel.font = [UIFont systemFontOfSize:24.0];
	subLabel.userInteractionEnabled = NO;
	
	subLabel.tag = SUB_LABEL_TAG;
	
	[view addSubview:subLabel];
	[subLabel release];
	return view;
}

#pragma mark -
#pragma mark Memory methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.datePicker = nil;
	self.timePicker = nil;
}


- (void)dealloc {
    [super dealloc];
	
}


@end
