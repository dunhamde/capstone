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

@synthesize delegate, wod, scoreField, hiddenButton, date, logNotes, table, dateFormatted, start;
@synthesize time_in_seconds, scoreNum, editingDate, editingScore, timeButton, timer;
@synthesize datePicker, timePicker, pickerView, datePickerView, stopWatchView, stopWatchButton;


- (void)viewDidLoad {
	[super viewDidLoad];
	//NSString *title = @"Log Score for ";
	//[self setTitle:[title stringByAppendingString:[wod name]]];
	[self setTitle:@"Log Score"];
	self.hiddenButton.enabled = NO;
	[datePicker setDate:[NSDate date]];
	
	timeButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 9, 60, 30)]; 
	[timeButton setTitle:@"Start!" forState:UIControlStateNormal];
	[timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[[timeButton titleLabel] setFont:[UIFont boldSystemFontOfSize:15]];
	UITapGestureRecognizer *tap = 
	[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeButtonPressed:)];
	[timeButton addGestureRecognizer:tap];
	[self makeButtonShiny:timeButton withBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:.80]];
	
	CGRect frame = self.datePickerView.frame;
	frame.origin.x = 0;
	frame.origin.y = 480;
	self.datePickerView.frame = frame;
	
	frame = self.pickerView.frame;
	frame.origin.x = 0;
	frame.origin.y = 480;
	self.pickerView.frame = frame;
	
	frame = self.stopWatchView.frame;
	frame.origin.x = 0;
	frame.origin.y = 480;
	self.stopWatchView.frame = frame;
	
	[self makeButtonShiny:stopWatchButton withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.87]];
	[stopWatchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[self.view addSubview:stopWatchView];

		
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
	//[title release];
	[tap release];

}

- (void)viewWillAppear:(BOOL)animated {
	// Register for exercises saved notifications
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc addObserver:self selector:@selector(notesChangedNote:) name:@"LogNotesSent" object:nil];
	[dnc addObserver:self selector:@selector(scoreNote:) name:@"ScoreSent" object:nil];
	[table reloadData];

}

- (void)scoreNote:(NSNotification*)saveNotification {
	NSLog(@"SCORE SENT");
	// Update 'Score' and refresh the table
	NSDictionary *dict = [saveNotification userInfo];

	[self setScoreNum:[[dict objectForKey:@"Text"] intValue]];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@":ScoreSent" object:nil];
	[table reloadData];
}

- (void)notesChangedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'Notes' and refresh the table
	[self setLogNotes:[dict objectForKey:@"Text"]];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@":LogNotesSent" object:nil];
}

- (void)updateTimer:(NSTimer*)timer {
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	NSTimeInterval interval = now - [self start];
	int seconds = (int)interval;
	
	[stopWatchButton setTitle:[NSString stringWithFormat:@"%02d:%02d", (seconds/60)%60, seconds%60] forState:UIControlStateNormal];
	[self setTime_in_seconds:seconds];
}

- (void)timeButtonPressed:(UITapGestureRecognizer *)recognizer {
		
	if ([[[[self timeButton] titleLabel] text] isEqualToString:@"Start!"]) {
		table.allowsSelection = NO;
		[stopWatchButton setTitle:[NSString stringWithFormat:@"%02d:%02d", 0, 0] forState:UIControlStateNormal];
		[timeButton setTitle:@"Stop!" forState:UIControlStateNormal];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.25];
		
		[timeButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.80]];
		
		[UIView commitAnimations];
		
		CGRect frame = self.stopWatchView.frame;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		
		frame.origin.y = 200;
		self.stopWatchView.frame = frame;
		
		[UIView commitAnimations];
		start = [NSDate timeIntervalSinceReferenceDate];
		timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
		
	} else {
		table.allowsSelection = YES;
		[timeButton setTitle:@"Start!" forState:UIControlStateNormal];
		[timer invalidate];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.25];
		
		[timeButton setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:.80]];
		
		[UIView commitAnimations];
		
		CGRect frame = self.stopWatchView.frame;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.5];
		
		frame.origin.y = 480;
		self.stopWatchView.frame = frame;
		
		[UIView commitAnimations];
		[table reloadData];
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
		self.editingDate = NO;
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
		self.editingScore = NO;
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
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
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
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
				if (time_in_seconds != 0) {
					int min = floor(time_in_seconds /60);
					int sec = trunc(time_in_seconds - min * 60);
					[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d min %d sec", min, sec]];					
				}
				
				// Add the timer button to the cell 
	

				[cell addSubview:timeButton];
				break;
			case WOD_SCORE_TYPE_REPS:
				[[cell textLabel] setText:@"Reps"];
				if ([self scoreNum] != 0) {
					[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%i", scoreNum]];
				}
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;
			case WOD_SCORE_TYPE_RNDS:
				[[cell textLabel] setText:@"Rounds"];
				if ([self scoreNum] != 0) {
					[[cell detailTextLabel] setText:[NSString stringWithFormat:@"%i", scoreNum]];
				}
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;
			default:
				break;
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
		
		if ([WOD wodScoreTypeToString:[[wod score_type] intValue] ] == @"Time") {
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
		}
		if ([WOD wodScoreTypeToString:[[wod score_type] intValue] ] == @"Reps") {
			EditViewController *controller = [[EditViewController alloc] init];
			
			[controller setTitleName:@"Reps"];
			[controller setNotificationName:@"ScoreSent"];
			[controller setEditType:EDIT_TYPE_NUMBER];
			[controller setDefaultText:nil];
			[controller setPopToRoot:NO];
			[[self navigationController] pushViewController:controller animated:YES];		
			
			[controller release];
		}
		if ([WOD wodScoreTypeToString:[[wod score_type] intValue] ] == @"Rounds") {
			EditViewController *controller = [[EditViewController alloc] init];
			
			[controller setTitleName:@"Rounds"];
			[controller setNotificationName:@"ScoreSent"];
			[controller setEditType:EDIT_TYPE_NUMBER];
			[controller setDefaultText:nil];
			[controller setPopToRoot:NO];
			[[self navigationController] pushViewController:controller animated:YES];		
			
			[controller release];
		}

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

- (void)makeButtonShiny:(UIButton*)button withBackgroundColor:(UIColor*)backgroundColor
{
    // Get the button layer and give it rounded corners with a semi-transparant button
    CALayer *layer = button.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 2.0f;
    layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
	
    // Create a shiny layer that goes on top of the button
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = button.layer.bounds;
    // Set the gradient colors
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    // Set the relative positions of the gradien stops
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
	
    // Add the layer to the button
    [button.layer addSublayer:shineLayer];
	
    [button setBackgroundColor:backgroundColor];
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

}


- (void)dealloc {
    [super dealloc];
	
}


@end
