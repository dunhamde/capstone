//
//  MainPageViewController.m
//  MyWODLog
//
//  Created by Derek on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainPageViewController.h"


@implementation MainPageViewController

@synthesize managedObjectContext;

- (void)buttonPressed:(UIButton *)sender {
	
/*	if (!wlvc) {
		wlvc = [[WODListViewController alloc] init];
		wlvc.managedObjectContext = [self managedObjectContext];
	}
	if (!createWOD) {
		createWOD = [[CreateWODViewController alloc] init];
	}
	if (!scores) {
		scores = [[ScoresViewController alloc] init];
		//
	}
	
	NSLog(@"Title label _%@_",sender.titleLabel.text);
		
	if ([sender.titleLabel.text isEqualToString: @"List WODs"]) {
		[[self navigationController] pushViewController:wlvc animated:YES];
	} else if ([sender.titleLabel.text isEqualToString: @"Create WOD"]) {
		[[self navigationController] pushViewController:createWOD animated:YES];
	} else if ([sender.titleLabel.text isEqualToString: @"Scores"]) {
		//[scores setRoot:self];  // Breaks badly, must get this to work at some point
		[[self navigationController] pushViewController:scores animated:YES];
	} */
	
}


- (void)wodListPressed {
	
	WODListViewController *wodList;
	
	// Set the back button to say "Home" instead of the title of this page
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	wodList = [[WODListViewController alloc] init];
	wodList.managedObjectContext = [self managedObjectContext];
	
	[[self navigationController] pushViewController:wodList animated:YES];
	
	[wodList release];
	
}


- (void)scoresPressed {
	
	ScoresViewController *scores;
	
	// Set the back button to say "Home" instead of the title of this page
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	scores = [[ScoresViewController alloc] init];
	
	[[self navigationController] pushViewController:scores animated:YES];
	
	[scores release];
}



- (void)viewDidLoad {    
    [super viewDidLoad];
	[self setTitle: @"My WOD Log"];	
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

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	
    [super dealloc];
}


@end
