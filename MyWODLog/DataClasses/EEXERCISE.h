//
//  EEXERCISE.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EXERCISE;
@class WOD;

@interface EEXERCISE :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * metric;
@property (nonatomic, retain) NSSet* wods;
@property (nonatomic, retain) EXERCISE * exercise;

@end


@interface EEXERCISE (CoreDataGeneratedAccessors)
- (void)addWodsObject:(WOD *)value;
- (void)removeWodsObject:(WOD *)value;
- (void)addWods:(NSSet *)value;
- (void)removeWods:(NSSet *)value;

@end

