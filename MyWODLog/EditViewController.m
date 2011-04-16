//
//  CreateExerciseModeViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"


@implementation EditViewController

@synthesize titleName,noteName;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:titleName];
    
    UIBarButtonItem *bbi;
    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                        target:self
                                                        action:@selector(save:)];
    [[self navigationItem] setRightBarButtonItem:bbi];
    [bbi release];
	
	
    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                        target:self
                                                        action:@selector(cancel:)];
    [[self navigationItem] setLeftBarButtonItem:bbi];
    [bbi release];
	
	
	// Why Auto-correction for numbers? (because it doesn't use dictionary?)
	[editField setAutocorrectionType:UITextAutocorrectionTypeNo];
}



- (void)viewDidAppear:(BOOL)animated
{
    [editField becomeFirstResponder];
}



- (IBAction)cancel:(id)sender
{
	[[self navigationController] popToRootViewControllerAnimated:YES];

}



- (IBAction)save:(id)sender
{
	
	// Create a dictionary with the exercise and the quantity and their respective keys
	NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:editField.text,nil] forKeys:[NSArray arrayWithObjects: @"Name",nil]];

	//NSDictionary *dict = [NSDictionary dictionaryWithObject:[self exercise] forKey:@"Exercise"];
	[[NSNotificationCenter defaultCenter] postNotificationName:noteName object:nil userInfo:dict];
	
	[[self navigationController] popToRootViewControllerAnimated:YES];
	
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



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
