//
//  ListEditViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListEditViewController : UITableViewController {
	
	NSString			*titleName;
	NSString			*notificationName;
	UIBarButtonItem		*saveButton;
	
	NSMutableArray		*elements;
}

// Button Action Methods:
- (void)cancel:(id)sender;
- (void)save:(id)sender;

@property (nonatomic, retain) NSString			*titleName;
@property (nonatomic, retain) NSString			*notificationName;
@property (nonatomic, retain) NSMutableArray	*elements;


@end
