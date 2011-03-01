//
//  MODE.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class exercise;

@interface MODE :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* exercises;

@end


@interface MODE (CoreDataGeneratedAccessors)
- (void)addExercisesObject:(exercise *)value;
- (void)removeExercisesObject:(exercise *)value;
- (void)addExercises:(NSSet *)value;
- (void)removeExercises:(NSSet *)value;

@end