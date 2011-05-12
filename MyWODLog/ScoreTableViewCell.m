//
//  ScoreTableViewCell.m
//  MyWODLog
//
//  Created by Derek Dunham on 5/2/11.
//  Copyright 2011 student. All rights reserved.
//

#import "ScoreTableViewCell.h"
#include <math.h>

#pragma mark -
#pragma mark SubviewFrames category

@interface ScoreTableViewCell (SubviewFrames)
- (CGRect)_wodNameFrame;
- (CGRect)_dateFrame;
- (CGRect)_scoreFrame;
- (CGRect)_notesFrame;

@end

#pragma mark -
#pragma mark ScoreTableViewCell implementation

@implementation ScoreTableViewCell

@synthesize score, wodNameLabel, dateLabel, scoreLabel, notesLabel;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
        dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [dateLabel setFont:[UIFont systemFontOfSize:12.0]];
        [dateLabel setTextColor:[UIColor darkGrayColor]];
        [dateLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:dateLabel];
		
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        scoreLabel.textAlignment = UITextAlignmentRight;
        [scoreLabel setFont:[UIFont systemFontOfSize:13.0]];
        [scoreLabel setTextColor:[UIColor blackColor]];
        [scoreLabel setHighlightedTextColor:[UIColor whiteColor]];
		scoreLabel.minimumFontSize = 7.0;
		scoreLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self.contentView addSubview:scoreLabel];
		
        wodNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [wodNameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [wodNameLabel setTextColor:[UIColor blackColor]];
        [wodNameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:wodNameLabel];
		
		notesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [notesLabel setFont:[UIFont systemFontOfSize:12.0]];
        [notesLabel setTextColor:[UIColor darkGrayColor]];
        [notesLabel setHighlightedTextColor:[UIColor whiteColor]];
		notesLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:notesLabel];
    }
	
    return self;
}


#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [wodNameLabel setFrame:[self _wodNameFrame]];
    [dateLabel setFrame:[self _dateFrame]];
	[notesLabel setFrame:[self _notesFrame]];
    [scoreLabel setFrame:[self _scoreFrame]];
    /*if (self.editing) {
        prepTimeLabel.alpha = 0.0;
    } else {
        prepTimeLabel.alpha = 1.0;
    }*/
}


//#define IMAGE_SIZE          42.0
//#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define SCORE_WIDTH     80.0
#define NOTES_WIDTH		200.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */

- (CGRect)_wodNameFrame {
	return CGRectMake( TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - TEXT_RIGHT_MARGIN * 2 - SCORE_WIDTH, 16.0);
}

- (CGRect)_dateFrame {
	return CGRectMake(TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - TEXT_LEFT_MARGIN, 16.0);
}

- (CGRect)_scoreFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - SCORE_WIDTH - TEXT_RIGHT_MARGIN, 4.0, SCORE_WIDTH, 16.0);
}

- (CGRect)_notesFrame {
	CGRect contentViewBounds = self.contentView.bounds;
	return CGRectMake(contentViewBounds.size.width / 2, 22.0, contentViewBounds.size.width / 2 - 5, 16.0);
}


#pragma mark -
#pragma mark Score set accessor

- (void)setScore:(SCORE *)newScore {
    if (newScore != score) {
        [score release];
        score = [newScore retain];
	}
	wodNameLabel.text = [[score wod] name];
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy"];
	dateLabel.text = [format stringFromDate:[score date]];
	[format release];
	notesLabel.text = [score notes];
	
	if ([[[score wod] score_type] intValue] == WOD_SCORE_TYPE_TIME ) {
		int minutes = floor([score.time doubleValue]/60);
		int seconds = trunc([score.time doubleValue] - minutes * 60);
		scoreLabel.text = [NSString stringWithFormat:@"%d min %d sec", minutes, seconds];
		
	}
	else if ([[[score wod] score_type] intValue] == WOD_SCORE_TYPE_REPS ) 
		scoreLabel.text = [NSString stringWithFormat:@"%d reps", [[score reps] intValue]];
	else {
		scoreLabel.text = [NSString stringWithFormat:@"%d rounds", [[score rounds] intValue]];
	}


}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [score release];
    [wodNameLabel release];
    [dateLabel release];
    [scoreLabel release];
    [super dealloc];
}

@end
