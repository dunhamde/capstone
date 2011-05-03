//
//  ScoreTableViewCell.h
//  MyWODLog
//
//  Created by Derek Dunham on 5/2/11.
//  Copyright 2011 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"SCORE.h"

@interface ScoreTableViewCell : UITableViewCell {

	SCORE *score;
    
    UILabel *wodNameLabel;
    UILabel *dateLabel;
    UILabel *scoreLabel;
}

@property (nonatomic, retain) SCORE *score;

@property (nonatomic, retain) UILabel *wodNameLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *scoreLabel;

@end

