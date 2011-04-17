//
//  EditViewController.h
//  MyWODLog
//
//  Created by Derek Dunham on 4/13/11.
//  Copyright 2011 student. All rights reserved.
//

#import <UIKit/UIKit.h>


#define EDIT_TYPE_NORMAL	1
#define EDIT_TYPE_NUMBER	2
#define EDIT_TYPE_TEXTBOX	3

#define DICTIONARY_KEY		@"Text"


@interface EditViewController : UIViewController {
	
	int editType;
	
	NSString	*titleName;
	NSString	*notificationName;
	NSString	*defaultText;
	NSString	*placeholder;
	
	UIBarButtonItem			*saveButton;
	IBOutlet UITextField	*editField;
	IBOutlet UITextView		*editBox;
	
}

// Button Action Methods:
- (void)cancel:(id)sender;
- (void)save:(id)sender;

// Misc. Methods:
- (void)initCustomEditPreferences;
- (int)editType;
- (NSString*)dictionaryKey;


@property (nonatomic, assign) int editType;
@property (nonatomic, retain) NSString *titleName;
@property (nonatomic, retain) NSString *notificationName;
@property (nonatomic, retain) NSString *defaultText;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) IBOutlet UITextField *editField;
@property (nonatomic, retain) IBOutlet UITextView *editBox;



@end
