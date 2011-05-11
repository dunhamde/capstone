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
	m = [self addMode:@"Gymnastics"];
	e = [self addExerciseToMode:m withName:@"MUSCLE-UPS"];
	e = [self addExerciseToMode:m withName:@"PULL-UPS"];
	e = [self addExerciseToMode:m withName:@"PUSH-UPS"];
	e = [self addExerciseToMode:m withName:@"SIT-UPS"];
	e = [self addExerciseToMode:m withName:@"SQUATS"];
	e = [self addExerciseToMode:m withName:@"Air squat"];
	e = [self addExerciseToMode:m withName:@"Sit up"];
	e = [self addExerciseToMode:m withName:@"Pull up"];
	e = [self addExerciseToMode:m withName:@"Push up"];
	e = [self addExerciseToMode:m withName:@"Handstand push up"];
	e = [self addExerciseToMode:m withName:@"Turkish get up"];
	e = [self addExerciseToMode:m withName:@"Walking lunge"];
	e = [self addExerciseToMode:m withName:@"Kipping pull up"];
	e = [self addExerciseToMode:m withName:@"Ring dips"];
	e = [self addExerciseToMode:m withName:@"Wall balls"];
	e = [self addExerciseToMode:m withName:@"Rope climb"];
	
	m = [self addMode:@"Mobility"];
	e = [self addExerciseToMode:m withName:@"Run # meter(s)" isQuantifiable:NO requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"Run # mile(s)" isQuantifiable:NO requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"Any sprint distance"];
	e = [self addExerciseToMode:m withName:@"Row # meter(s)" isQuantifiable:NO requiresMetric:YES];
	e = [self addExerciseToMode:m withName:@"Burpee"];
	e = [self addExerciseToMode:m withName:@"Box jump"];
	e = [self addExerciseToMode:m withName:@"Jump rope"];
	e = [self addExerciseToMode:m withName:@"Double unders"];
	
	m = [self addMode:@"Weight Lifting"];
	e = [self addExerciseToMode:m withName:@"Front squat"];
	e = [self addExerciseToMode:m withName:@"Back squat"];
	e = [self addExerciseToMode:m withName:@"Clean & Jerk"];
	e = [self addExerciseToMode:m withName:@"Hang power clean"];
	e = [self addExerciseToMode:m withName:@"Deadlift"];
	e = [self addExerciseToMode:m withName:@"Thruster"];
	e = [self addExerciseToMode:m withName:@"Snatch"];
	e = [self addExerciseToMode:m withName:@"Power press"];
//	e = [self addExerciseToMode:m withName:@"BENCH, BODY WEIGHT"];
	e = [self addExerciseToMode:m withName:@"Bench press"];
	e = [self addExerciseToMode:m withName:@"Overhead squats"];
	e = [self addExerciseToMode:m withName:@"Power snatch"];
	e = [self addExerciseToMode:m withName:@"Sumo deadlift"];
	e = [self addExerciseToMode:m withName:@"Kettlebell swing"];
	e = [self addExerciseToMode:m withName:@"SNATCH, # POUNDS"];

	
	/*
	 #define WOD_SCORE_TYPE_NONE		0
	 #define WOD_SCORE_TYPE_TIME		1
	 #define WOD_SCORE_TYPE_REPS		2
	 #define WOD_SCORE_TYPE_RNDS		3
	 
	 #define WOD_TYPE_UNKNOWN		0
	 #define WOD_TYPE_TIME			1
	 #define WOD_TYPE_RFT			2	// Rounds For Time (RFT)
	 #define WOD_TYPE_RRFT			3	// Rep Rounds For Time (RRFT)
	 #define WOD_TYPE_RFMR			4	// Rounds For Max Rep (RFMR)
	 #define WOD_TYPE_AMRAP			5	// As Many Rounds As Possible (AMRAP)
	 #define WOD_TYPE_EMOTM			6	// Each Minute On The Minute (EMOTM)
	 */
	
	// #### [AMANDA] ####
	w = [self addWOD:@"AMANDA"];
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_RRFT]];
	
	NSMutableArray* amandaRounds = [NSMutableArray arrayWithCapacity:0];
	
	r = [self addRepRound:@"9"];
	[amandaRounds addObject:r];
	r = [self addRepRound:@"7"];
	[amandaRounds addObject:r];
	r = [self addRepRound:@"5"];
	[amandaRounds addObject:r];
	
	enumer = [amandaRounds objectEnumerator];
	while( (r = (RROUND*)[enumer nextObject]) ) {
		[w addRroundsObject:r];
	}
	
	ee = [self addEExercise:@"SNATCH, # POUNDS" quantity:0 metric:@"135"];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"MUSCLE-UPS" quantity:0 metric:nil];
	[w addEexercisesObject:ee];
	// #### [/AMANDA] ####
	
	
	
	// #### [ANGIE] ####
	w = [self addWOD:@"ANGIE"];
	
	[w setScore_type:[[NSNumber alloc] initWithInt:WOD_SCORE_TYPE_TIME]];
	[w setType:[[NSNumber alloc] initWithInt:WOD_TYPE_TIME]];

	ee = [self addEExercise:@"PULL-UPS" quantity:100 metric:nil];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"PUSH-UPS" quantity:100 metric:nil];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SIT-UPS" quantity:100 metric:nil];
	[w addEexercisesObject:ee];
	ee = [self addEExercise:@"SQUATS" quantity:100 metric:nil];
	[w addEexercisesObject:ee];
	// #### [/ANGIE] ####
	
	w = [self addWOD:@"Annie"];
	w = [self addWOD:@"Barbara"];
	w = [self addWOD:@"Betty"];	
	w = [self addWOD:@"Candy"];
	w = [self addWOD:@"Chelsea"];
	w = [self addWOD:@"Charlotte"];	
	w = [self addWOD:@"Christine"];
	w = [self addWOD:@"Cindy"];
	w = [self addWOD:@"Diane"];	
	w = [self addWOD:@"Elizabeth"];
	w = [self addWOD:@"Eva"];
	w = [self addWOD:@"Fran"];	
	w = [self addWOD:@"GI Jane"];
	w = [self addWOD:@"Grace"];
	w = [self addWOD:@"Gwen"];	
	w = [self addWOD:@"Helen"];
	w = [self addWOD:@"Isabel"];
	w = [self addWOD:@"Jackie"];
	w = [self addWOD:@"Karen"];
	w = [self addWOD:@"Kelly"];
	w = [self addWOD:@"Linda"];	
	w = [self addWOD:@"Lola"];
	w = [self addWOD:@"Lynne"];
	w = [self addWOD:@"Mary"];	
	w = [self addWOD:@"Maggie"];
	w = [self addWOD:@"Nancy"];
	w = [self addWOD:@"Nasty Girls"];	
	w = [self addWOD:@"Nicole"];
	w = [self addWOD:@"Pukie Brewster"];
	
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



- (RROUND*)addRepRound:(NSString*)numReps {
	
	// If the rep round is already in the DB, return it instead of creating a new one
	NSEnumerator *enumerR = [[self repRounds] objectEnumerator];
	RROUND* r = nil;
	
	while ( (r = (RROUND*)[enumerR nextObject]) ) {
		if ( [[r reps] isEqualToString:numReps] ) {
			return r;
		}
	}
	
	RROUND* rround = (RROUND *)[NSEntityDescription insertNewObjectForEntityForName:@"rround" inManagedObjectContext:[self managedObjectContext]];
	
	[rround setReps:numReps];
	
	[[self repRounds] addObject:rround];
	
	return rround;
}


- (EEXERCISE*)addEExercise:(NSString*)exerciseName quantity:(int)qty metric:(NSString*)met {
	
	NSLog(@"----1");
	// If the rep round is already in the DB, return it instead of creating a new one
	NSEnumerator *enumerE = [[self exercises] objectEnumerator];
	EXERCISE* e = nil;
	
	while ( (e = (EXERCISE*)[enumerE nextObject]) ) {
		if ( [[e name] isEqualToString:exerciseName] ) {
			break;
		}
	}
	NSLog(@"----2");
	if (e != nil) {
		NSLog(@"----3");
		EEXERCISE* ee = (EEXERCISE *)[NSEntityDescription insertNewObjectForEntityForName:@"eexercise" inManagedObjectContext:[self managedObjectContext]];
	NSLog(@"----4 name = %@", exerciseName);
		//TODO: replace name's '#' symbol with metric if exercise requires metric
		[ee setExercise:e];
		[ee setName:exerciseName];
		[ee setQuantity:[[NSNumber alloc] initWithInt:qty]];
		[ee setMetric:met];
		
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
