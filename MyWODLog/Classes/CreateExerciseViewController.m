//
//  CreateExerciseViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateExerciseViewController.h"


@implementation CreateExerciseViewController

//@synthesize exercise;
@synthesize name, nameField, delegate, metricRequired, quantifiable;

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
	
	[self setTitle:@"Add Exercise"];
	
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
	[nameField setAutocorrectionType:UITextAutocorrectionTypeNo];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (void)viewDidAppear:(BOOL)animated
{
    [nameField becomeFirstResponder];
}





- (IBAction)cancel:(id)sender
{
	
    [self setName:nil];
	[delegate createExerciseViewController:self didFinishWithSave:NO];
	
}



- (IBAction)save:(id)sender
{
	
	if ([[nameField text] length] > 0) {
		BOOL canSave = NO;
		
		// If 
		if ([metricRequired isOn]) {
			
			NSRange range = [[nameField text] rangeOfString:@"#"];
			if ( range.location == NSNotFound || range.length == 0 ) {
				
				UIAlertView *alert = nil;
				alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
												   message:@"A '#' symbol is required since this exercise requires a metric.  The '#' symbol denotes where the metric should be placed once this exercise is added to a specific WOD.  Please add a '#' symbol (without the quotes) to the exercise name (where it makes sense) or disable the metric requirement."
												  delegate:nil
										 cancelButtonTitle:@"Ok"
										 otherButtonTitles:nil];
				[alert show];
				[alert release];
				alert = nil;
				
				
			} else {
				canSave = YES;
			}

			
		} else {
			canSave = YES;
		}

		
		if (canSave) {
			[self setName:[nameField text]];
			[delegate createExerciseViewController:self didFinishWithSave:YES];
		}
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

	[name release];
    [super dealloc];
}


@end
