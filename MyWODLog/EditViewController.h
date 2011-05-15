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
#define DICTIONARY_KEY2		@"Text2"


@interface EditViewController : UIViewController {
	
	int editType;
	
	NSString	*titleName;
	NSString	*notificationName;
	NSString	*defaultText;
	NSString	*placeholder;
	NSString	*defaultText2;
	NSString	*placeholder2;
	
	UIBarButtonItem			*saveButton;
	IBOutlet UITextField	*editField;
	IBOutlet UITextField	*editField2;
	IBOutlet UITextView		*editBox;
	
	BOOL popToRoot;
	BOOL requireInputToSave;
	BOOL enableEditField2;
	
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
@property (nonatomic, retain) NSString *defaultText2;
@property (nonatomic, retain) NSString *placeholder2;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UITextField *editField;
@property (nonatomic, retain) IBOutlet UITextField *editField2;
@property (nonatomic, retain) IBOutlet UITextView *editBox;
@property (nonatomic, assign) BOOL popToRoot;
@property (nonatomic, assign) BOOL enableEditField2;
@property (nonatomic, assign) BOOL requireInputToSave;



@end
