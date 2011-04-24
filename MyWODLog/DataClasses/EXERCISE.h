//
//  EXERCISE.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class EEXERCISE;
@class MODE;

@interface EXERCISE :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) MODE * modes;
@property (nonatomic, retain) NSSet* eexercises;

@end


@interface EXERCISE (CoreDataGeneratedAccessors)
- (void)addEexercisesObject:(EEXERCISE *)value;
- (void)removeEexercisesObject:(EEXERCISE *)value;
- (void)addEexercises:(NSSet *)value;
- (void)removeEexercises:(NSSet *)value;

@end

