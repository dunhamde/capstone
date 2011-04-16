//
//  EditViewController.h
//  MyWODLog
//
//  Created by Derek Dunham on 4/13/11.
//  Copyright 2011 student. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditViewController : UIViewController {
	
	NSString	*titleName;
	NSString	*noteName;
	UIBarButtonItem	*saveButton;
	IBOutlet UITextField	*editField;
	
}


- (void)cancel:(id)sender;
- (void)save:(id)sender;

@property (nonatomic, retain) NSString *titleName;
@property (nonatomic, retain) NSString *noteName;


@end
