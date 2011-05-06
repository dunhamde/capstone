//
//  LogScoreViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogScoreViewController.h"


@implementation LogScoreViewController

@synthesize delegate, wod, scoreField, scoreLabel, timeButton, hiddenButton, date, start_date, dateField;
@synthesize time_in_seconds, hours, minutes, seconds;
@synthesize saveButton;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
	[super viewDidLoad];
	NSString *title = @"Log Score for ";
	[self setTitle:[title stringByAppendingString:[wod name]]];
	self.hiddenButton.enabled = NO;

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
            break;
        case WOD_SCORE_TYPE_TIME:
			self.scoreLabel.text = @"Time";
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
		
		NSString *placeholder = [[[[NSNumber numberWithInt:minutes] stringValue] stringByAppendingString:@":"] stringByAppendingString:[[NSNumber numberWithInt:seconds] stringValue]];
		[scoreField setPlaceholder:placeholder];
		[timeButton setTitle:@"Start Timer!" forState:UIControlStateNormal];
	}	
}

- (void)scoreFieldTouched {
	//NSLog(@"score TOUCHED");
	[hiddenButton setUserInteractionEnabled:YES];
	self.hiddenButton.enabled = YES;
}

- (void)hiddenButtonTouched {
	//NSLog(@"hidden TOUCHED");
	self.hiddenButton.enabled = NO;
	[scoreField resignFirstResponder];
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


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
