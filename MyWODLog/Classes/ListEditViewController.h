//
//  ListEditViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"


@interface ListEditViewController : UITableViewController <UITableViewDelegate> {
	
	NSString			*titleName;
	NSString			*notificationName;
	NSString			*addTitleName;
	UIBarButtonItem		*saveButton;
	
	NSMutableArray		*elements;
}



@property (nonatomic, retain) NSString			*titleName;
@property (nonatomic, retain) NSString			*notificationName;
@property (nonatomic, retain) NSString			*addTitleName;
@property (nonatomic, retain) NSMutableArray	*elements;


// Button Action Methods:
- (void)addElement;



// Notifications:
- (void)elementAddedNote:(NSNotification*)saveNotification;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
