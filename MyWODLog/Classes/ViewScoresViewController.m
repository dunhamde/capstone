//
//  ViewScoresViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewScoresViewController.h"


@implementation ViewScoresViewController


- (id)init {
	// Call the superclass's designated initializer
	//[super initWithStyle:UITableViewStyleGrouped];
	
	toolbar = [[UIToolbar alloc] init];
	toolbar.barStyle = UIBarStyleDefault;
	[toolbar sizeToFit];
	//[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	// Set the title of the nav bar to WOD List when WODListViewController
	// is on top of the stack
	[self setTitle:@"View Scores"];
//	[[self navigationController] toolbarHidden:NO];

//	self.navigationController.toolbarHidden = YES;
	
	return self;
}



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
