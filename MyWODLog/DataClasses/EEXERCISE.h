//
//  EEXERCISE.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EXERCISE;
@class WOD;

@interface EEXERCISE :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) EXERCISE * exercise;
@property (nonatomic, retain) NSSet* wods;

@end


@interface EEXERCISE (CoreDataGeneratedAccessors)
- (void)addWodsObject:(WOD *)value;
- (void)removeWodsObject:(WOD *)value;
- (void)addWods:(NSSet *)value;
- (void)removeWods:(NSSet *)value;
// Adding these below got rid of the warnings:  (remove them if crashes occur)
- (void)setQuantity:(NSNumber *)value;
- (void)quantity;
- (void)setExercise:(EXERCISE *)value;
- (void)exercise;
@end

