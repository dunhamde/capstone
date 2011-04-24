//
//  RROUND.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class WOD;

@interface RROUND :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * reps;
@property (nonatomic, retain) NSSet* wods;

@end


@interface RROUND (CoreDataGeneratedAccessors)
- (void)addWodsObject:(WOD *)value;
- (void)removeWodsObject:(WOD *)value;
- (void)addWods:(NSSet *)value;
- (void)removeWods:(NSSet *)value;

@end

