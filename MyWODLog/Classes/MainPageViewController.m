//
//  MainPageViewController.m
//  MyWODLog
//
//  Created by Derek on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainPageViewController.h"


@implementation MainPageViewController

@synthesize testLabel;


- (void)buttonPressed:(UIButton *)sender {
	
	if (!wlvc) {
		wlvc = [[WODListViewController alloc] init];
	}
	
	NSLog(@"Title label _%@_",sender.titleLabel.text);
		
	if ([sender.titleLabel.text isEqualToString: @"List WODs"]) {
		[[self navigationController] pushViewController:wlvc animated:YES];
	}
}

- (void)viewDidLoad {    
    [super viewDidLoad];
	[self setTitle: @"Main Page"];	
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.testLabel = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	
    [super dealloc];
}


@end
