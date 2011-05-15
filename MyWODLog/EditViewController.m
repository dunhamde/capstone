//
//  CreateExerciseModeViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"


@implementation EditViewController

@synthesize titleName, notificationName, saveButton, editField, editBox, editType, defaultText, placeholder;
@synthesize popToRoot, requireInputToSave;
@synthesize enableEditField2, editField2, defaultText2, placeholder2;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization.
		[self setPopToRoot:YES];
		[self setEnableEditField2:NO];
		[self setRequireInputToSave:YES];
	}
	return self;
}
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self setTitle:[self titleName]];
	
	// Set Save Button:
    UIBarButtonItem *bbi;
    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                        target:self
                                                        action:@selector(save:)];
	[self setSaveButton:bbi];
    [[self navigationItem] setRightBarButtonItem:bbi];
    [bbi release];
	
	// Set Cancel Button:
    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                        target:self
                                                        action:@selector(cancel:)];
    [[self navigationItem] setLeftBarButtonItem:bbi];
    [bbi release];
	
	
	[self initCustomEditPreferences];

}



- (void)viewDidAppear:(BOOL)animated
{
	if ([self editType] == EDIT_TYPE_TEXTBOX) {
		[[self editBox] becomeFirstResponder];
	} else {
		[[self editField] becomeFirstResponder];
	}
}


- (NSString*)dictionaryKey
{
	return DICTIONARY_KEY;
}


- (void)initCustomEditPreferences
{

	// Center Text Field Text:
	self.editField.textAlignment = UITextAlignmentCenter;
	self.editField2.textAlignment = UITextAlignmentCenter;
	
	self.editField2.enabled = NO;
	self.editField2.hidden = YES;
	
	switch ([self editType]) {
		case EDIT_TYPE_NORMAL:
			self.editField.keyboardType = UIKeyboardTypeDefault;
			self.editField.hidden = NO;
			self.editField.enabled = YES;
			if ([self enableEditField2]) {
				self.editField2.keyboardType = UIKeyboardTypeDefault;
				self.editField2.hidden = NO;
				self.editField2.enabled = YES;
			}
			self.editBox.hidden = YES;
			break;
		case EDIT_TYPE_NUMBER:
			self.editField.keyboardType = UIKeyboardTypeNumberPad;
			self.editField.hidden = NO;
			self.editField.enabled = YES;
			if ([self enableEditField2]) {
				self.editField2.keyboardType = UIKeyboardTypeNumberPad;
				self.editField2.hidden = NO;
				self.editField2.enabled = YES;
			}
			self.editBox.hidden = YES;
			break;
		case EDIT_TYPE_TEXTBOX:
			self.editField.hidden = YES;
			self.editField.enabled = NO;
			self.editField2.hidden = YES;
			self.editField2.enabled = NO;
			self.editBox.keyboardType = UIKeyboardTypeDefault;
			self.editBox.hidden = NO;
			break;
		default:
			[self setEditType:EDIT_TYPE_NORMAL];
			[self initCustomEditPreferences];
			break;
	}
	// Why Auto-correction for numbers? (because it doesn't use dictionary?)
	[[self editField] setAutocorrectionType:UITextAutocorrectionTypeNo];
	[[self editBox] setAutocorrectionType:UITextAutocorrectionTypeNo];
	
	// Set default text #1:
	if ([self defaultText] != nil && [[self defaultText] length] > 0) {
		if (self.editBox.hidden) {
			self.editField.text = [self defaultText];
		} else {
			self.editBox.text = [self defaultText];
		}
	} else if([self placeholder] != nil && [[self placeholder] length] > 0) {
		if (self.editBox.hidden) {
			self.editField.placeholder = [self placeholder];
		} else {
			//Note: UITextView (editBox) do not have placeholders
		}

	}
	
	// Set default text #2:
	if ([self defaultText2] != nil && [[self defaultText2] length] > 0) {
		if (self.editBox.hidden) {
			self.editField2.text = [self defaultText2];
		}
	} else if ([self placeholder2] != nil && [[self placeholder2] length] > 0) {
		if (self.editBox.hidden) {
			self.editField2.placeholder = [self placeholder2];
		}
	}
	
}



- (IBAction)cancel:(id)sender
{
	[[self navigationController] popToRootViewControllerAnimated:YES];
}



- (IBAction)save:(id)sender
{
	BOOL canSave = YES;
	
	if ([self requireInputToSave]) {
		if (![[self editField] isHidden] && [[[self editField] text] length] == 0) {
			canSave = NO;
		}
		if (![[self editField2] isHidden] && [[[self editField2] text] length] == 0) {
			canSave = NO;
		}
		if (![[self editBox] isHidden] && [[[self editBox] text] length] == 0) {
			canSave = NO;
		}
	}
	
	
	if (canSave) {
		
		// Create a dictionary with the exercise and the quantity and their respective keys
		NSString *returnable;
		NSString *returnable2;
		
		if (self.editField.hidden == YES) {
			returnable = [[self editBox] text];
		}
		else {
			returnable = [[self editField] text];
			if ([self enableEditField2]) {
				returnable2 = [[self editField2] text];
			}
		}
		
		NSDictionary *dict = nil;
		
		if ([self enableEditField2]) {
			dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:returnable,returnable2,nil] forKeys:[NSArray arrayWithObjects:DICTIONARY_KEY,DICTIONARY_KEY2,nil]];
		} else {
			dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:returnable,nil] forKeys:[NSArray arrayWithObjects:DICTIONARY_KEY,nil]];
		}
		
		
		
		[[NSNotificationCenter defaultCenter] postNotificationName:[self notificationName] object:nil userInfo:dict];
		
		if ([self popToRoot]) {
			[[self navigationController] popToRootViewControllerAnimated:YES];
		} else {
			[[self navigationController] popViewControllerAnimated:YES];
		}
		
	} else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message: @"Input is required to save" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		alert = nil;
		
	}
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
