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



- (void)wodListPressed {
	
	WODListViewController *wodList;
	
	// Set the back button to say "Home" instead of the title of this page
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];

	[[self navigationItem] setBackBarButtonItem:backButton];
	[backButton release];
	
	wodList = [[WODListViewController alloc] init];
	[wodList setManagedObjectContext:[self managedObjectContext]];

	
	[[self navigationController] pushViewController:wodList animated:YES];
	
	[wodList release];
	
}


- (void)scoresPressed {
	
	// Set the back button to say "Home" instead of the title of this page
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
	[[self navigationItem] setBackBarButtonItem:backButton];

	[backButton release];
	
	ViewScoresViewController *controller = [[ViewScoresViewController alloc] init];

	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
	
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
