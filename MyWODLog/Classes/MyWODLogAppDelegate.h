//
//  MyWODLogAppDelegate.h
//  MyWODLog
//
//  Created by Derek on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MODE.h"
#import "EXERCISE.h"
#import "WOD.h"

@class MainPageViewController;

@interface MyWODLogAppDelegate : NSObject <UIApplicationDelegate> {

	NSPersistentStoreCoordinator	*persistentStoreCoordinator;
    NSManagedObjectModel			*managedObjectModel;
    NSManagedObjectContext			*managedObjectContext;
	
	MainPageViewController			*mpvc;
    UIWindow						*window;
}

@property (nonatomic, retain) IBOutlet UIWindow							*window;
@property (nonatomic, retain) IBOutlet MainPageViewController			*mpvc;

@property (nonatomic, retain, readonly) NSManagedObjectContext			*managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel			*managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator	*persistentStoreCoordinator;



- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;


- (BOOL)needsDefaultData;
- (void)generateDefaultData;



- (MODE*)addMode:(NSString*)name;
- (EXERCISE*)addExerciseToMode:(MODE*)mode withName:(NSString*)name;
- (WOD*)addWOD:(NSString*)name;


@end

