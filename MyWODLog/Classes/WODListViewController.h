//
//  WODListViewController.h
//  MyWODLog
//
//  Created by Derek on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewWODViewController.h"

@interface WODListViewController : UITableViewController {

	NSMutableArray *wodlist;
	ViewWODViewController *vwvc;
}

@end
