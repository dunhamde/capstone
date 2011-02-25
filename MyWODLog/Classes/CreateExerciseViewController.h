//
//  CreateExerciseViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EXERCISE.h"


@interface CreateExerciseViewController : UIViewController {
	
	EXERCISE *exercise;
	
}

@property (nonatomic, retain) EXERCISE *exercise;

@end
