//
//  SetExerciseQuantityViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXERCISE.h"


@interface SetExerciseQuantityViewController : UIViewController {
	
	EXERCISE *exercise;

}

@property (nonatomic, retain) EXERCISE *exercise;

@end
