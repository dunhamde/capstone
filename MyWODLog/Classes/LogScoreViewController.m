//
//  LogScoreViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogScoreViewController.h"


@implementation LogScoreViewController

@synthesize wod, timeField, repsField, timeLabel, repsLabel, timeButton, date, start_date;
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
	
	// Configure the save button.
	[self setSaveButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)]];
	[[self saveButton] setEnabled:YES];
	[[self navigationItem] setRightBarButtonItem:[self saveButton]];
	[saveButton release];
	
	NSLog(@"Score Type: %@", [wod score_type]);
	switch ([[wod score_type] intValue]) {
        case WOD_SCORE_TYPE_NONE:
            break;
        case WOD_SCORE_TYPE_TIME:
            self.repsField.hidden = YES;
			self.repsField.enabled = NO;
			self.repsLabel.hidden = YES;
			self.repsLabel.enabled = NO;
            break;
		case WOD_SCORE_TYPE_REPS:
            break;
		case WOD_SCORE_TYPE_RNDS:
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
		// Found this next secion on stackoverflow for getting minutes and seconds between two dates
		
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
		[timeField setPlaceholder:placeholder];
		[timeButton setTitle:@"Start Timer!" forState:UIControlStateNormal];
	}	
}

- (IBAction)save:(id)sender	{
	
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
