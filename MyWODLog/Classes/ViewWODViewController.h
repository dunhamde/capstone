//
//  ViewWODViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LogScoreViewController.h"
#import "WOD.h"
#import "EXERCISE.h"


@interface ViewWODViewController : UIViewController <UITableViewDelegate> {

	WOD *wod;
	NSArray *exerciseArray;
	
	IBOutlet UILabel *scoredByLabel;
	//IBOutlet UILabel *exerciseListLabel;
	IBOutlet UITableView *table;
}

@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) UILabel *scoredByLabel;
//@property (nonatomic, retain) UILabel *exerciseListLabel;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *exerciseArray;

- (void)setCurrentWOD:(WOD *)w;

- (IBAction)logScorePressed;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
