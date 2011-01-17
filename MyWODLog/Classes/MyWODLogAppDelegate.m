//
//  MyWODLogAppDelegate.m
//  MyWODLog
//
//  Created by Derek on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyWODLogAppDelegate.h"
#import "MainPageViewController.h";

@implementation MyWODLogAppDelegate

@synthesize window;
@synthesize mpvc;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Create MainPageViewController
	mpvc = [[MainPageViewController alloc] init];
	
	// Create an instance of a UINavigationController
	// its stack contains only itemsViewController
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mpvc];
	
	//Place navigation controller's view in the window hierarchy
	[window addSubview:[navController view]];
	
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc {
	[mpvc release];
    [window release];
    [super dealloc];
}


@end
