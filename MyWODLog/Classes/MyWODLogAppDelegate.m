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
@synthesize repRounds;
@synthesize exercises;


#pragma mark -
#pragma mark Application lifecycle



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Create MainPageViewController
	[self setMpvc:[[MainPageViewController alloc] init]];
	[[self mpvc] setManagedObjectContext:[self managedObjectContext]];

	
	// Create an instance of a UINavigationController
	// its stack contains only itemsViewController
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[self mpvc]];
	
	//Place navigation controller's view in the window hierarchy
	[[self window] addSubview:[navController view]];
	
    [[self window] makeKeyAndVisible];
	
	if ([self needsDefaultData]) {
		[self generateDefaultData];
	}
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}



- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext_ = [self managedObjectContext];
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    






#pragma mark -
#pragma mark Core Data stack



/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
//		    NSLog(@"Creating managed object context");
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}



/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}



/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyWODLog.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator;
}



#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Default Data



- (BOOL)needsDefaultData {
	BOOL need = NO;
	
	//NSString *queryString = [NSString stringWithFormat:@"name == '%@'", [self wodName] ];
	
	// Create and configure a fetch request with the wod entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"exercise" inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:entity];
	//[fetchRequest setPredicate:[NSPredicate predicateWithFormat:queryString]];
	
	NSError *error = nil; 
	NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	// Throw up an error message if the WOD already exists.
	if( error || [array count] <= 0) {
		NSLog(@"NEEDS TO GENERATE DEFAULT DATA");
		need = YES;
	} else {
		NSLog(@"DOES NOT NEED TO GENERATE DEFAULT DATA");
	}
	
	[fetchRequest release];
	
	return need;

}



- (void)generateDefaultData {
	
	//TODO: should everything be capitalized?
	[self setExercises:[NSMutableArray arrayWithCapacity:0]];
	[self setRepRounds:[NSMutableArray arrayWithCapacity:0]];
	
	MODE*			m = nil;
	EXERCISE*		e = nil;
	WOD*			w = nil;
	RROUND*			r = nil;
	EEXERCISE*		ee = nil;
	NSEnumerator*	enumer = nil;
	
	
	// Add everything to the MOC
	m = [self addMode:@"GYMNASTICS"];
	e = [self addExerciseToMode:m withName:@"MUSCLE-UPS"];
	e = [self addExerciseToMode:m withName:@"PULL-UPS"];
	e = [self addExerciseToMode:m withName:@"PUSH-UPS"];
	e = [self addExerciseToMode:m withName:@"SIT-UPS"];
	e = [self addExerciseToMode:m withName:@"SQUATS"];
	e = [self addExerciseToMode:m withName:@"HANDSTAND PUSH-UPS"];
	e = [self addExerciseToMode:m withName:@"RING DIPS"];
	e = [self addExerciseToMode:m withName:@"BURPEE-PULL-UPS"];
	e = [self addExerciseToMode:m withName:@"TOUCH AND GO"];
	e = [self addExerciseToMode:m withName:@"L PULL-UPS"];
	e = [self addExerciseToMode:m withName:@"WALKING LUNGES"];
	e = [self addExerciseToMode:m withName:@"ONE-LEGGED SQUATS"];
	e = [self addExerciseToMode:m withName:@"MAX REP PULL-UPS"];
	
	
////	e = [self addExerciseToMode:m withName:@"Air squat"];
	//e = [self addExerciseToMode:m withName:@"Sit up"];
	//e = [self addExerciseToMode:m withName:@"Pull up"];
	//e = [self addExerciseToMode:m withName:@"Push up"];
	//e = [self addExerciseToMode:m withName:@"Handstand push up"];
////	e = [self addExerciseToMode:m withName:@"Turkish get up"];
////	e = [self addExerciseToMode:m withName:@"Walking lunge"];
////	e = [self addExerciseToMode:m withName:@"Kipping pull up"];
//	e = [self addExerciseToMode:m withName:@"Ring dips"];
////	e = [self addExerciseToMode:m withName:@"Wall balls"];
////	e = [self addExerciseToMode:m withName:@"Rope climb"];
	
	m = [self addMode:@"MOBILITY"];
	e = [self addExerciseToMode:m withName:@"DOUBLE-UNDERS"];
	e = [self addExerciseToMode:m withName:@"BOX JUMP, # INCH BOX" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"ROW # METERS" isQuantifiable:NO requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"RUN # METERS" isQuantifiable:NO requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"BURPEES"];
//	e = [self addExerciseToMode:m withName:@"Run # meter(s)" isQuantifiable:NO requiresMetric:YES];
////	e = [self addExerciseToMode:m withName:@"Run # mile(s)" isQuantifiable:NO requiresMetric:YES];
////	e = [self addExerciseToMode:m withName:@"Any sprint distance"];
//	e = [self addExerciseToMode:m withName:@"Row # meter(s)" isQuantifiable:NO requiresMetric:YES];
//	e = [self addExerciseToMode:m withName:@"Burpee"];
////	e = [self addExerciseToMode:m withName:@"Box jump"];
////	e = [self addExerciseToMode:m withName:@"Jump rope"];
	//e = [self addExerciseToMode:m withName:@"Double unders"];
	
	m = [self addMode:@"WEIGHT LIFTING"];
////	e = [self addExerciseToMode:m withName:@"Front squat"];
////	e = [self addExerciseToMode:m withName:@"Back squat"];
//	e = [self addExerciseToMode:m withName:@"Clean & Jerk"];
//	e = [self addExerciseToMode:m withName:@"Hang power clean"];
//	e = [self addExerciseToMode:m withName:@"Deadlift"];
//	e = [self addExerciseToMode:m withName:@"Thruster"];
//	e = [self addExerciseToMode:m withName:@"Snatch"];
//	e = [self addExerciseToMode:m withName:@"Power press"];
//	e = [self addExerciseToMode:m withName:@"BENCH, BODY WEIGHT"];
//	e = [self addExerciseToMode:m withName:@"Bench press"];
//	e = [self addExerciseToMode:m withName:@"Overhead squats"];
//	e = [self addExerciseToMode:m withName:@"Power snatch"];
////	e = [self addExerciseToMode:m withName:@"Sumo deadlift"];
//	e = [self addExerciseToMode:m withName:@"Kettlebell swing"];
	e = [self addExerciseToMode:m withName:@"SNATCH, # POUNDS" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"PUSH PRESS, # POUNDS" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"OVERHEAD SQUATS, # POUNDS" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"SUMO-DEADLIFT HIGH-PULL"];
	e = [self addExerciseToMode:m withName:@"DEADLIFT, BODY WEIGHT"];
	e = [self addExerciseToMode:m withName:@"DEADLIFT, # BODY WEIGHT" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"DEADLIFT, # POUNDS" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"CLEAN, # POUNDS" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"CLEAN, # BODY WEIGHT" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"KETTLEBELL SWING, # POODS" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"THRUSTERS, # POUNDS" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"CLEAN & JERK, # POUNDS" isQuantifiable:YES requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"CLEAN & JERK"];	
	e = [self addExerciseToMode:m withName:@"WALL-BALL SHOTS, # POUNDS" isQuantifiable:YES requiresMetric:YES];
//	e = [self addExerciseToMode:m withName:@"BENCH, BODY WEIGHT"];
	e = [self addExerciseToMode:m withName:@"BENCH PRESS, BODY WEIGHT"];  // same thing as bench?
	e = [self addExerciseToMode:m withName:@"HANG POWER CLEAN, # POUNDS" isQuantifiable:YES requiresMetric:YES];	

	
	
	/////                    ////
	//        THE GIRLS        //
	////                    /////
	
	
	// #### [AMANDA] ####
	w = [self addWOD:@"AMANDA"];
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];
	
	NSMutableArray* amandaRounds = [NSMutableArray arrayWithCapacity:0];
	
	r = [self addRepRound:@"9" order:1];
	[amandaRounds addObject:r];
	r = [self addRepRound:@"7" order:2];
	[amandaRounds addObject:r];
	r = [self addRepRound:@"5" order:3];
	[amandaRounds addObject:r];
	
	enumer = [amandaRounds objectEnumerator];
	while( (r = (RROUND*)[enumer nextObject]) ) {
		[w addRroundsObject:r];
	}
	
	ee = [self addEExercise:@"SNATCH, # POUNDS" quantity:0 metric:@"135" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"MUSCLE-UPS" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	// #### [/AMANDA] ####
	
	
	
	// #### [ANGIE] ####
	w = [self addWOD:@"ANGIE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_TIME]];

	NSMutableArray *angieExercises = [NSMutableArray arrayWithCapacity:0];
	
	ee = [self addEExercise:@"PULL-UPS" quantity:100 metric:nil order:1];
	[angieExercises addObject:ee];
	ee = [self addEExercise:@"PUSH-UPS" quantity:100 metric:nil order:2];
	[angieExercises addObject:ee];
	ee = [self addEExercise:@"SIT-UPS" quantity:100 metric:nil order:3];
	[angieExercises addObject:ee];
	ee = [self addEExercise:@"SQUATS" quantity:100 metric:nil order:4];
	[angieExercises addObject:ee];
	
	
	NSSet *angieSet = [[NSSet alloc] initWithArray:angieExercises];
	[w setEexercises:angieSet];
	/*ee = [self addEExercise:@"PULL-UPS" quantity:100 metric:nil];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PUSH-UPS" quantity:100 metric:nil];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SIT-UPS" quantity:100 metric:nil];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SQUATS" quantity:100 metric:nil];
	[w addEexercisesObject:ee];*/
	// #### [/ANGIE] ####

	
	
	// [ANNIE]
	w = [self addWOD:@"ANNIE"];

	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];
	
	r = [self addRepRound:@"50" order:1];
	[w addRroundsObject:r];
	r = [self addRepRound:@"40" order:2];
	[w addRroundsObject:r];
	r = [self addRepRound:@"30" order:3];
	[w addRroundsObject:r];
	r = [self addRepRound:@"20" order:4];
	[w addRroundsObject:r];
	r = [self addRepRound:@"10" order:5];
	[w addRroundsObject:r];
	
	ee = [self addEExercise:@"DOUBLE-UNDERS" quantity:0 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SIT-UPS" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	// [/ANNIE]
	
	
	
	// [BARBARA]
	w = [self addWOD:@"BARBARA"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:5]];
	
	ee = [self addEExercise:@"PULL-UPS" quantity:20 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PUSH-UPS" quantity:30 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SIT-UPS" quantity:40 metric:nil order:3];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SQUATS" quantity:50 metric:nil order:4];
	[w addEexercisesObject:ee];
	// [/BARBARA]
	
	
	
	// [BETTY]
	w = [self addWOD:@"BETTY"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:5]];
	
	ee = [self addEExercise:@"PUSH PRESS, # POUNDS" quantity:12 metric:@"135" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"BOX JUMP, # INCH BOX" quantity:20 metric:@"24" order:2];
	[w addEexercisesObject:ee];
	// [/BETTY]
	
	
	
	// [CANDY]
	w = [self addWOD:@"CANDY"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:5]];
	
	ee = [self addEExercise:@"PULL-UPS" quantity:20 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PUSH-UPS" quantity:40 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SQUATS" quantity:60 metric:nil order:3];
	[w addEexercisesObject:ee];
	// [/CANDY]
	
	
	
	// [CHELSEA]
	w = [self addWOD:@"CHELSEA"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_NONE]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_EMOTM]];
	[w setTimelimit:[[NSNumber alloc] initWithInt:30]];
	
	ee = [self addEExercise:@"PULL-UPS" quantity:5 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PUSH-UPS" quantity:10 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SQUATS" quantity:15 metric:nil order:3];
	[w addEexercisesObject:ee];
	// [/CHELSEA]
	
	
	
	// [CHARLOTTE]
	w = [self addWOD:@"CHARLOTTE"];	
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];

	r = [self addRepRound:@"21" order:1];
	[w addRroundsObject:r];
	r = [self addRepRound:@"15" order:2];
	[w addRroundsObject:r];
	r = [self addRepRound:@"9" order:3];
	[w addRroundsObject:r];
	
	ee = [self addEExercise:@"OVERHEAD SQUATS, # POUNDS" quantity:0 metric:@"95" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SUMO-DEADLIFT HIGH-PULL" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	// [/CHARLOTTE]
	
	
	
	// [CHRISTINE]
	w = [self addWOD:@"CHRISTINE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:3]];
	
	ee = [self addEExercise:@"ROW # METERS" quantity:0 metric:@"500" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"DEADLIFT, BODY WEIGHT" quantity:12 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"BOX JUMP, # INCH BOX" quantity:21 metric:@"24" order:3];
	[w addEexercisesObject:ee];
	// [/CHRISTINE]
	
	
	
	// [CINDY]
	w = [self addWOD:@"CINDY"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_RNDS]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_AMRAP]];
	
	[w setTimelimit:[[NSNumber alloc] initWithInt:20]];
	
	ee = [self addEExercise:@"PULL-UPS" quantity:5 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PUSH-UPS" quantity:10 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SQUATS" quantity:15 metric:nil order:3];
	[w addEexercisesObject:ee];
	// [/CINDY]
	
	
	
	// [DIANE]
	w = [self addWOD:@"DIANE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];
	
	r = [self addRepRound:@"21" order:1];
	[w addRroundsObject:r];
	r = [self addRepRound:@"15" order:2];
	[w addRroundsObject:r];
	r = [self addRepRound:@"9" order:3];
	[w addRroundsObject:r];
	
	ee = [self addEExercise:@"DEADLIFT, # POUNDS" quantity:0 metric:@"225" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"HANDSTAND PUSH-UPS" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	// [/DIANE]
	
	
	
	// [ELIZABETH]
	w = [self addWOD:@"ELIZABETH"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];
	
	r = [self addRepRound:@"21" order:1];
	[w addRroundsObject:r];
	r = [self addRepRound:@"15" order:2];
	[w addRroundsObject:r];
	r = [self addRepRound:@"9" order:3];
	[w addRroundsObject:r];
	
	ee = [self addEExercise:@"CLEAN, # POUNDS" quantity:0 metric:@"135" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"RING DIPS" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	// [/ELIZABETH]
	
	
	
	// [EVA]
	w = [self addWOD:@"EVA"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:5]];
	
	ee = [self addEExercise:@"RUN # METERS" quantity:0 metric:@"800" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"KETTLEBELL SWING, # POODS" quantity:30 metric:@"2" order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PULL-UPS" quantity:30 metric:nil order:3];
	[w addEexercisesObject:ee];
	// [/EVA]
	
	
	
	// [FRAN]
	w = [self addWOD:@"FRAN"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];
	
	r = [self addRepRound:@"21" order:1];
	[w addRroundsObject:r];
	r = [self addRepRound:@"15" order:2];
	[w addRroundsObject:r];
	r = [self addRepRound:@"9" order:3];
	[w addRroundsObject:r];
	
	ee = [self addEExercise:@"THRUSTERS, # POUNDS" quantity:0 metric:@"95" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PULL-UPS" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	// [/FRAN]
	
	
	
	// [GI JANE]
	w = [self addWOD:@"GI JANE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_TIME]];

	ee = [self addEExercise:@"BURPEE-PULL-UPS" quantity:100 metric:nil order:1];
	[w addEexercisesObject:ee];
	// [/GI JANE]
	
	
	
	// [GRACE]
	w = [self addWOD:@"GRACE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_TIME]];
	
	ee = [self addEExercise:@"CLEAN & JERK, # POUNDS" quantity:30 metric:@"135" order:1];
	[w addEexercisesObject:ee];
	// [/GRACE]
	
	
	
	// [GWEN]
	w = [self addWOD:@"GWEN"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];
	
	r = [self addRepRound:@"12" order:1];
	[w addRroundsObject:r];
	r = [self addRepRound:@"9" order:2];
	[w addRroundsObject:r];
	r = [self addRepRound:@"6" order:3];
	[w addRroundsObject:r];
	
	ee = [self addEExercise:@"TOUCH AND GO" quantity:0 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"CLEAN & JERK" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	// [/GWEN]
	
	
	
	// [HELEN]
	w = [self addWOD:@"HELEN"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:3]];
	
	ee = [self addEExercise:@"RUN # METERS" quantity:0 metric:@"400" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"KETTLEBELL SWING, # POODS" quantity:21 metric:@"1.5" order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PULL-UPS" quantity:12 metric:nil order:3];
	[w addEexercisesObject:ee];
	// [/HELEN]
	
	
	
	// [ISABEL]
	w = [self addWOD:@"ISABEL"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_TIME]];
	
	ee = [self addEExercise:@"SNATCH, # POUNDS" quantity:30 metric:@"135" order:1];
	[w addEexercisesObject:ee];
	// [/ISABEL]
	
	
	
	// [JACKIE]
	w = [self addWOD:@"JACKIE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_TIME]];
	
	ee = [self addEExercise:@"ROW # METERS" quantity:0 metric:@"1000" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"THRUSTERS, # POUNDS" quantity:50 metric:@"45" order:2];
	[w addEexercisesObject:ee];
	// [/JACKIE]
	
	
	
	// [KAREN]
	w = [self addWOD:@"KAREN"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_TIME]];
	
	ee = [self addEExercise:@"WALL-BALL SHOTS, # POUNDS" quantity:150 metric:@"20" order:1];
	[w addEexercisesObject:ee];
	// [/KAREN]
	
	
	
	// [KELLY]
	w = [self addWOD:@"KELLY"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:3]];
	
	ee = [self addEExercise:@"RUN # METERS" quantity:0 metric:@"400" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"BOX JUMP, # INCH BOX" quantity:30 metric:@"24" order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"WALL-BALL SHOTS, # POUNDS" quantity:30 metric:@"20" order:3];
	[w addEexercisesObject:ee];
	// [/KELLY]
	
	
	
	// [LINDA]
	w = [self addWOD:@"LINDA"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];
	
	r = [self addRepRound:@"10" order:1];
	[w addRroundsObject:r];
	r = [self addRepRound:@"9" order:2];
	[w addRroundsObject:r];
	r = [self addRepRound:@"8" order:3];
	[w addRroundsObject:r];
	r = [self addRepRound:@"7" order:4];
	[w addRroundsObject:r];
	r = [self addRepRound:@"6" order:5];
	[w addRroundsObject:r];
	r = [self addRepRound:@"5" order:6];
	[w addRroundsObject:r];
	r = [self addRepRound:@"4" order:7];
	[w addRroundsObject:r];
	r = [self addRepRound:@"3" order:8];
	[w addRroundsObject:r];
	r = [self addRepRound:@"2" order:9];
	[w addRroundsObject:r];
	r = [self addRepRound:@"1" order:10];
	[w addRroundsObject:r];
	
	ee = [self addEExercise:@"DEADLIFT, # BODY WEIGHT" quantity:0 metric:@"1 1/2" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"BENCH PRESS, BODY WEIGHT" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"CLEAN, # BODY WEIGHT" quantity:0 metric:@"3/4" order:3];
	[w addEexercisesObject:ee];
	// [/LINDA]
	
	
	
	// [LOLA]
	w = [self addWOD:@"LOLA"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_RNDS]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_AMRAP]];
	
	[w setTimelimit:[[NSNumber alloc] initWithInt:20]];
	
	ee = [self addEExercise:@"L PULL-UPS" quantity:5 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PUSH-UPS" quantity:10 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"WALKING LUNGES" quantity:15 metric:nil order:3];
	[w addEexercisesObject:ee];
	// [/LOLA]
	
	
	
	// [LYNNE]
	w = [self addWOD:@"LYNNE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_REPS]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFMR]];
	
	ee = [self addEExercise:@"BENCH PRESS, BODY WEIGHT" quantity:0 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PULL-UPS" quantity:0 metric:nil order:2];
	[w addEexercisesObject:ee];
	// [/LYNNE]
	
	
	
	// [MARY]
	w = [self addWOD:@"MARY"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_RNDS]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_AMRAP]];
	
	ee = [self addEExercise:@"HANDSTAND PUSH-UPS" quantity:5 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"ONE-LEGGED SQUATS" quantity:10 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PULL-UPS" quantity:15 metric:nil order:3];
	[w addEexercisesObject:ee];
	// [/MARY]
	
	
	
	// [MAGGIE]
	w = [self addWOD:@"MAGGIE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:5]];
	
	ee = [self addEExercise:@"HANDSTAND PUSH-UPS" quantity:20 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PULL-UPS" quantity:40 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"ONE-LEGGED SQUATS" quantity:60 metric:nil order:3];
	[w addEexercisesObject:ee];
	// [/MAGGIE]
	
	
	
	// [NANCY]
	w = [self addWOD:@"NANCY"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:5]];
	
	ee = [self addEExercise:@"RUN # METERS" quantity:0 metric:@"400" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"OVERHEAD SQUATS, # POUNDS" quantity:15 metric:@"95" order:2];
	[w addEexercisesObject:ee];
	// [/NANCY]
	
	
	
	// [NASTY GIRLS]
	w = [self addWOD:@"NASTY GIRLS"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RFT]];
	
	[w setRounds:[[NSNumber alloc] initWithInt:3]];
	
	ee = [self addEExercise:@"SQUATS" quantity:50 metric:nil order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"MUSCLE-UPS" quantity:7 metric:nil order:2];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"HANG POWER CLEAN, # POUNDS" quantity:10 metric:@"135" order:3];
	[w addEexercisesObject:ee];
	// [/NASTY GIRLS]
	
	
	
	// [NICOLE]
	w = [self addWOD:@"NICOLE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_RNDS]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_AMRAP]];
	
	[w setTimelimit:[[NSNumber alloc] initWithInt:20]];
	
	ee = [self addEExercise:@"RUN # METERS" quantity:0 metric:@"400" order:1];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"MAX REP PULL-UPS" quantity:10 metric:nil order:2];
	[w addEexercisesObject:ee];
	[w setNotes:@"Note the number of pull-ups completed each round"];
	// [/NICOLE]
	
	
	
	// [PUKIE BREWSTER]
	w = [self addWOD:@"PUKIE BREWSTER"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_TIME]];
	
	ee = [self addEExercise:@"BURPEES" quantity:150 metric:nil order:1];
	[w addEexercisesObject:ee];
	// [/PUKIE BREWSTER]
	
	
	
	// Finally save everything in the MOC:
	NSError *error;
	if (![[self managedObjectContext] save:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

}



- (WOD*)addWOD:(NSString*)name {
	
	WOD* wod = (WOD *)[NSEntityDescription insertNewObjectForEntityForName:@"wod" inManagedObjectContext:[self managedObjectContext]];
	
	[wod setName:name];
	
	return wod;
	
}



- (MODE*)addMode:(NSString*)name {
	
	MODE* mode = (MODE *)[NSEntityDescription insertNewObjectForEntityForName:@"mode" inManagedObjectContext:[self managedObjectContext]];
	
	[mode setName:name];
	
	return mode;
	
}



- (EXERCISE*)addExerciseToMode:(MODE*)mode withName:(NSString*)name {
	
	EXERCISE* exercise = (EXERCISE *)[NSEntityDescription insertNewObjectForEntityForName:@"exercise" inManagedObjectContext:[self managedObjectContext]];
	
	[exercise setName:name];
	[exercise setModes:mode];
	[exercise setQuantifiable:[[NSNumber alloc] initWithBool:YES]];
	[exercise setRequiresMetric:[[NSNumber alloc] initWithBool:NO]];
	
	[[self exercises] addObject:exercise];
	
	return exercise;
	
}


- (EXERCISE*)addExerciseToMode:(MODE*)mode withName:(NSString*)name isQuantifiable:(BOOL)quantifiable requiresMetric:(BOOL)metricRequired {

	EXERCISE* exercise = (EXERCISE *)[NSEntityDescription insertNewObjectForEntityForName:@"exercise" inManagedObjectContext:[self managedObjectContext]];
	
	[exercise setName:name];
	[exercise setModes:mode];
	[exercise setQuantifiable:[[NSNumber alloc] initWithBool:quantifiable]];
	[exercise setRequiresMetric:[[NSNumber alloc] initWithBool:metricRequired]];
	
	[[self exercises] addObject:exercise];
	
	return exercise;

}



- (RROUND*)addRepRound:(NSString*)numReps order:(NSInteger)o {
	
	// If the rep round is already in the DB, return it instead of creating a new one
	NSEnumerator *enumerR = [[self repRounds] objectEnumerator];
	RROUND* r = nil;
	
	while ( (r = (RROUND*)[enumerR nextObject]) ) {
		if ( [[r reps] isEqualToString:numReps] && [[r order] intValue] == o  ) {
			return r;
		}
	}
	
	RROUND* rround = (RROUND *)[NSEntityDescription insertNewObjectForEntityForName:@"rround" inManagedObjectContext:[self managedObjectContext]];
	
	[rround setReps:numReps];
	[rround setOrder:[[NSNumber alloc] initWithInt:o]];
	
	[[self repRounds] addObject:rround];
	
	return rround;
}


- (EEXERCISE*)addEExercise:(NSString*)exerciseName quantity:(int)qty metric:(NSString*)met order:(int)o {
	
	// If the rep round is already in the DB, return it instead of creating a new one
	NSEnumerator *enumerE = [[self exercises] objectEnumerator];
	EXERCISE* e = nil;
	
	while ( (e = (EXERCISE*)[enumerE nextObject]) ) {
		if ( [[e name] isEqualToString:exerciseName] ) {
			break;
		}
	}

	if (e != nil) {

		EEXERCISE* ee = (EEXERCISE *)[NSEntityDescription insertNewObjectForEntityForName:@"eexercise" inManagedObjectContext:[self managedObjectContext]];

		// Replace '#' with the actual metric
		NSString* ename = exerciseName;
		
		if ([[e requiresMetric] boolValue]) {
			
			NSRange range = [exerciseName rangeOfString:@"#"];
			ename = [exerciseName stringByReplacingCharactersInRange:range withString:met];
			
		}

		[ee setExercise:e];
		[ee setName:ename];
		[ee setQuantity:[[NSNumber alloc] initWithInt:qty]];
		[ee setMetric:met];
		[ee setOrder:[[NSNumber alloc] initWithInt:o]];
		
		return ee;
		
	}
	
	return nil;
}


#pragma mark -
#pragma mark Memory management



- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



- (void)dealloc {
	
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[mpvc release];
    [window release];
    [super dealloc];
}


@end
