//
//  LogScoreViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogScoreViewController.h"
#import <math.h>

@implementation LogScoreViewController

@synthesize delegate, wod, scoreField, timeButton, hiddenButton, date, start_date, logNotes, table, dateFormatted;
@synthesize time_in_seconds, hours, minutes, seconds, editingDate, editingScore;
@synthesize datePicker, timePicker, pickerView, datePickerView;


- (void)viewDidLoad {
	[super viewDidLoad];
	NSString *title = @"Log Score for ";
	[self setTitle:[title stringByAppendingString:[wod name]]];
	self.hiddenButton.enabled = NO;
	
	CGRect frame = self.datePickerView.frame;
	frame.origin.x = 0;
	frame.origin.y = 480;
	self.datePickerView.frame = frame;
	
	frame = self.pickerView.frame;
	frame.origin.x = 0;
	frame.origin.y = 480;
	self.pickerView.frame = frame;
		
	// Configure the save button.
	UIBarButtonItem	*saveButton;
	saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	[[self navigationItem] setRightBarButtonItem:saveButton];
	[saveButton release];
	
	// Set dateField to current date by default
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy"];
	NSString *curDate = [format stringFromDate:[NSDate date]];
	//[[self dateField] setText:curDate];
	[self setDate:[NSDate date]];
	[self setDateFormatted:curDate];
	
	[format release];
	[title release];

}

- (void)viewWillAppear:(BOOL)animated {
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


- (void)hiddenButtonTouched {
	self.hiddenButton.enabled = NO;
	
	// Check to see if the user is trying to stop setting the date. If the hiddenButton is pressed while the Date Picker is up, close it.
	if (editingDate) {
		
		CGRect frame = self.datePickerView.frame;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		
		frame.origin.y = 480;
		self.datePickerView.frame = frame;
		
		[UIView commitAnimations];
		
		table.allowsSelection = YES;
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MM/dd/yyyy"];
		NSString *newDate = [format stringFromDate:[datePicker date]];
		NSLog(@"%@",newDate);
		[self setDateFormatted:newDate];	
		[self setDate:[datePicker date]];
		[format release];
		[table reloadData];
	}
	else if (editingScore) {
		CGRect frame = self.pickerView.frame;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		
		frame.origin.y = 480;
		self.pickerView.frame = frame;
		
		[UIView commitAnimations];
		
		table.allowsSelection = YES;

		[table reloadData];
	}
	
}

- (void)dateViewTouched:(UITapGestureRecognizer *)recognizer {

	 
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
#pragma mark Tableview methods

// Customize the number of rows in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return LS_NUM_SECTIONS;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    NSString *title = nil;
	
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case LS_SECTION_DATE:
            title = LS_SECTION_TITLE_DATE;
            break;
        case LS_SECTION_SCORE:
            title = LS_SECTION_TITLE_SCORE;
            break;
		case LS_SECTION_NOTES:
            title = LS_SECTION_TITLE_NOTES;
            break;
        default:
            break;
    }
	
    return title;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger rows = 0;
	
	switch (section) {
        case LS_SECTION_DATE:
			rows = 1;
            break;
        case LS_SECTION_SCORE:
            rows = 1;
            break;
        case LS_SECTION_NOTES:
            rows = 1;
            break;			
        default:
            break;
    }
	
    return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( [indexPath section] == LS_SECTION_DATE && [indexPath row] == 0 ) {
		
		static NSString *DateCellIdentifier = @"DateCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DateCellIdentifier] autorelease];
			
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
		
    }
	else if ( [indexPath section] == LS_SECTION_SCORE && [indexPath row] == 0 ) {
		
		static NSString *ScoreCellIdentifier = @"ScoreCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ScoreCellIdentifier] autorelease];
			[cell setAccessoryView:timeButton];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
	}
	else if ( [indexPath section] == LS_SECTION_NOTES && [indexPath row] == 0 ) {
		
		static NSString *NotesCellIdentifier = @"NotesCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NotesCellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NotesCellIdentifier] autorelease];
		}
		
		// Configure the cell.
		[self configureCell:cell atIndexPath:indexPath];
		
		return cell;
	}
	
	return nil;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	// Can't we do this by cell name instead of section/row numbers?
	// i.e.:  [cell reuseIdentifier]  << returns a string
	
	NSString *cellIdentifier = [cell reuseIdentifier];
	
	if( [cellIdentifier isEqualToString:@"DateCell"] ) {
		
		[[cell textLabel] setText:@"Date"];
		[[cell detailTextLabel] setText:dateFormatted];
		
	}
	else if( [cellIdentifier isEqualToString:@"ScoreCell"] ) {
		
		switch ([[wod score_type] intValue]) {
			case WOD_SCORE_TYPE_NONE:
				[[cell textLabel] setText:@"Completed"];
				break;
			case WOD_SCORE_TYPE_TIME:
				[[cell textLabel] setText:@"Time"];
				break;
			case WOD_SCORE_TYPE_REPS:
				[[cell textLabel] setText:@"Reps"];
				break;
			case WOD_SCORE_TYPE_RNDS:
				[[cell textLabel] setText:@"Rounds"];
				break;
			default:
				break;
		}			
		
		if (time_in_seconds != 0) {
			int min = floor(time_in_seconds /60);
			int sec = trunc(time_in_seconds - min * 60);
			[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d min %d sec", min, sec]];
			
			
		}
		
	}
	else if( [cellIdentifier isEqualToString:@"NotesCell"] ) {
		
		if ([self logNotes] != nil && [[self logNotes] length] > 0) {
			[[cell textLabel] setText:[self logNotes]];
		} else {
			[[cell textLabel] setText:@"Add Notes..."];
		}
	}		
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( [indexPath section] == LS_SECTION_DATE && [indexPath row] == 0 ) {	

		table.allowsSelection = NO;
		self.editingDate = YES;
		self.hiddenButton.enabled = YES;

		CGRect frame = self.datePickerView.frame;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		
		[self.view addSubview:datePickerView];
		frame.origin.y = 200;
		self.datePickerView.frame = frame;
		
		[UIView commitAnimations];
		
		
	}
	else if ([indexPath section] == LS_SECTION_SCORE && [indexPath row] == 0 ) {	
		
		table.allowsSelection = NO;
		self.editingScore = YES;
		self.hiddenButton.enabled = YES;
		
		CGRect frame = self.pickerView.frame;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		
		[self.view addSubview:pickerView];
		frame.origin.y = 200;
		self.pickerView.frame = frame;
		
		[UIView commitAnimations];
	} else {
		EditViewController *controller = [[EditViewController alloc] init];
		
		[controller setTitleName:@"Log Notes"];
		[controller setNotificationName:@"LogNotesSent"];
		[controller setEditType:EDIT_TYPE_TEXTBOX];
		[controller setDefaultText:[self logNotes]];
		[controller setPopToRoot:NO];
		[[self navigationController] pushViewController:controller animated:YES];		
		
		[controller release];
	}

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
