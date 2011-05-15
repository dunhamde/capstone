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
#import "RROUND.h"

@class MainPageViewController;

@interface MyWODLogAppDelegate : NSObject <UIApplicationDelegate> {

	NSPersistentStoreCoordinator	*persistentStoreCoordinator;
    NSManagedObjectModel			*managedObjectModel;
    NSManagedObjectContext			*managedObjectContext;
	
	MainPageViewController			*mpvc;
    UIWindow						*window;
	
	
	NSMutableArray					*repRounds;
	NSMutableArray					*exercises;
	
}

@property (nonatomic, retain) IBOutlet UIWindow							*window;
@property (nonatomic, retain) IBOutlet MainPageViewController			*mpvc;

@property (nonatomic, retain, readonly) NSManagedObjectContext			*managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel			*managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator	*persistentStoreCoordinator;

@property (nonatomic, retain) NSMutableArray							*repRounds;
@property (nonatomic, retain) NSMutableArray							*exercises;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;


- (BOOL)needsDefaultData;
- (void)generateDefaultData;



- (MODE*)addMode:(NSString*)name;
- (EXERCISE*)addExerciseToMode:(MODE*)mode withName:(NSString*)name;
- (EXERCISE*)addExerciseToMode:(MODE*)mode withName:(NSString*)name isQuantifiable:(BOOL)quantifiable requiresMetric:(BOOL)metricRequired;
- (WOD*)addWOD:(NSString*)name;
- (RROUND*)addRepRound:(NSString*)numReps;
- (EEXERCISE*)addEExercise:(NSString*)exerciseName quantity:(int)qty metric:(NSString*)met order:(int)o;


@end

