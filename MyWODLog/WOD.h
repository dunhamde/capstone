//
//  WOD.h
//  MyWODLog
//
//  Created by Derek Dunham on 1/29/11.
//  Copyright 2011 student. All rights reserved.
//

#import <CoreData/CoreData.h>
#define WOD_SCORE_TYPE_TIME 0
#define WOD_SCORE_TYPE_REPS 1

@interface WOD :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * timelimit;
@property (nonatomic, retain) NSNumber * score_type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* exercises;

@end


@interface WOD (CoreDataGeneratedAccessors)
- (void)addExercisesObject:(NSManagedObject *)value;
- (void)removeExercisesObject:(NSManagedObject *)value;
- (void)addExercises:(NSSet *)value;
- (void)removeExercises:(NSSet *)value;

@end



