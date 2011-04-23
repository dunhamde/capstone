//
//  ListEditViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListEditViewController : UITableViewController <UITableViewDelegate> {
	
	NSString			*titleName;
	NSString			*notificationName;
	UIBarButtonItem		*saveButton;
	
	NSMutableArray		*elements;
}



@property (nonatomic, retain) NSString			*titleName;
@property (nonatomic, retain) NSString			*notificationName;
@property (nonatomic, retain) NSMutableArray	*elements;


// Button Action Methods:
- (void)cancel:(id)sender;
- (void)save:(id)sender;


// Notifications:
- (void)elementAddedNote:(NSNotification*)saveNotification;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
