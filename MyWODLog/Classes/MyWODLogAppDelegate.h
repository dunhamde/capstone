//
//  MyWODLogAppDelegate.h
//  MyWODLog
//
//  Created by Derek on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainPageViewController;

@interface MyWODLogAppDelegate : NSObject <UIApplicationDelegate> {
	MainPageViewController *mpvc;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet MainPageViewController *mpvc;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

