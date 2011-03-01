//
//  EXERCISE.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MODE;
@class WOD;

@interface EXERCISE :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) MODE * modes;
@property (nonatomic, retain) NSSet* wod;

@end


@interface EXERCISE (CoreDataGeneratedAccessors)
- (void)addWodObject:(WOD *)value;
- (void)removeWodObject:(WOD *)value;
- (void)addWod:(NSSet *)value;
- (void)removeWod:(NSSet *)value;

@end