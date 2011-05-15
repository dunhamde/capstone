//
//  WOD.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>



#define WOD_SCORE_TYPE_NONE			0
#define WOD_SCORE_TYPE_TIME			1
#define WOD_SCORE_TYPE_REPS			2
#define WOD_SCORE_TYPE_RNDS			3

#define WOD_SCORE_TYPE_TEXT_NONE	@"None"
#define WOD_SCORE_TYPE_TEXT_TIME	@"Time"
#define WOD_SCORE_TYPE_TEXT_REPS	@"Reps"
#define WOD_SCORE_TYPE_TEXT_RNDS	@"Rounds"

#define WOD_TYPE_UNKNOWN			0
#define WOD_TYPE_TIME				1
#define WOD_TYPE_RFT				2	// Rounds For Time (RFT)
#define WOD_TYPE_RRFT				3	// Rep Rounds For Time (RRFT)
#define WOD_TYPE_RFMR				4	// Rounds For Max Rep (RFMR)
#define WOD_TYPE_AMRAP				5	// As Many Rounds As Possible (AMRAP)
#define WOD_TYPE_EMOTM				6	// Each Minute On The Minute (EMOTM)

#define NUM_WOD_TYPES				6

#define WOD_TYPE_TEXT_UNKNOWN		@"Unspecified"
#define WOD_TYPE_TEXT_TIME			@"For Time"
#define WOD_TYPE_TEXT_RFT			@"Rounds For Time"
#define WOD_TYPE_TEXT_RRFT			@"Rep Rounds For Time"
#define WOD_TYPE_TEXT_RFMR			@"Rounds For Max Rep"
#define WOD_TYPE_TEXT_AMRAP			@"As Many Rounds As Possible"
#define WOD_TYPE_TEXT_EMOTM			@"Each Minute On The Minute"


@class EEXERCISE;
@class RROUND;
@class SCORE;

@interface WOD :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * rounds;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * timelimit;
@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSNumber * score_type;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* scores;
@property (nonatomic, retain) NSSet* rrounds;
@property (nonatomic, retain) NSSet* eexercises;

+ (NSString*)wodTypeToString:(NSUInteger)wodType;
+ (NSString*)wodScoreTypeToString:(NSUInteger)wodScoreType;

@end


@interface WOD (CoreDataGeneratedAccessors)
- (void)addScoresObject:(SCORE *)value;
- (void)removeScoresObject:(SCORE *)value;
- (void)addScores:(NSSet *)value;
- (void)removeScores:(NSSet *)value;

- (void)addRroundsObject:(RROUND *)value;
- (void)removeRroundsObject:(RROUND *)value;
- (void)addRrounds:(NSSet *)value;
- (void)removeRrounds:(NSSet *)value;

- (void)addEexercisesObject:(EEXERCISE *)value;
- (void)removeEexercisesObject:(EEXERCISE *)value;
- (void)addEexercises:(NSSet *)value;
- (void)removeEexercises:(NSSet *)value;

@end

