//
//  WOD.h
//  MyWODLog
//
//  Created by Derek Dunham on 1/29/11.
//  Copyright 2011 student. All rights reserved.
//

#import <CoreData/CoreData.h>

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

#define NUM_WOD_TYPES			6

#define WOD_TYPE_TEXT_UNKNOWN	@"Unspecified"
#define WOD_TYPE_TEXT_TIME		@"For Time"
#define WOD_TYPE_TEXT_RFT		@"Rounds For Time"
#define WOD_TYPE_TEXT_RRFT		@"Rep Rounds For Time"
#define WOD_TYPE_TEXT_RFMR		@"Rounds For Max Rep"
#define WOD_TYPE_TEXT_AMRAP		@"As Many Rounds As Possible"
#define WOD_TYPE_TEXT_EMOTM		@"Each Minute On The Minute"


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



