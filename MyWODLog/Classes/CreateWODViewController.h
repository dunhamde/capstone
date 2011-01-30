//
//  CreateWODViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOD.h"

@interface CreateWODViewController : UIViewController <UITextFieldDelegate> {
	
	NSManagedObjectContext *managedObjectContext;
	WOD *wod;
	UITextField *name;
	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) IBOutlet UITextField *name;

@end