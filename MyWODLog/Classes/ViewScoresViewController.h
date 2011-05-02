//
//  ViewScoresViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewScoresViewController : UIViewController {
	
	UIToolbar *toolbar;
	IBOutlet UITableView *table;
	
	NSArray	*curScores;

}

@property (nonatomic, retain) IBOutlet UITableView *table;

@property (nonatomic, retain) NSArray	*curScores;



@end
