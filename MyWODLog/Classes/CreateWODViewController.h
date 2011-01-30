//
//  CreateWODViewController.h
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOD.h"

@protocol CreateWODViewControllerDelegate;


@interface CreateWODViewController : UIViewController <UITextFieldDelegate> {
	
	id <CreateWODViewControllerDelegate> delegate;
	NSManagedObjectContext *managedObjectContext;
	WOD *wod;
	UITextField *name;

}

@property (nonatomic, assign) id <CreateWODViewControllerDelegate> delegate;
@property (nonatomic, retain) WOD *wod;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) IBOutlet UITextField *name;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol CreateWODViewControllerDelegate
- (void)createWODViewController:(CreateWODViewController *)controller didFinishWithSave:(BOOL)save;
@end