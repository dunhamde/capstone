//
//  WOD.h
//  MyWODLog
//
//  Created by Derek Dunham on 1/29/11.
//  Copyright 2011 student. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface WOD :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * wod_id;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * timelimit;
@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSManagedObject * score_type;

@end



