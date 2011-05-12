//
//  SCORE.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class WOD;

@interface SCORE :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * rounds;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) WOD * wod;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * notes;

@end



