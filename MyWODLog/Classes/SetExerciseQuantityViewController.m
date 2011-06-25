//
//  SetExerciseQuantityViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetExerciseQuantityViewController.h"


@implementation SetExerciseQuantityViewController

@synthesize exercise, quantityField, metricField, getMetric, getQuantity;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		[self setGetMetric:NO];
		[self setGetQuantity:NO];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];

	
	UIBarButtonItem *bbi;
    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                        target:self
                                                        action:@selector(save:)];
    [[self navigationItem] setRightBarButtonItem:bbi];
    [bbi release];
	
	if ([self getMetric] && [self getQuantity]) {
		[self setTitle:@"Set Quantity and Metric"];
		self.metricField.enabled = YES;
		self.metricField.hidden = NO;
		self.metricField.placeholder = @"Weight/Distance/Other Metric";
		self.quantityField.enabled = YES;
		self.quantityField.hidden = NO;
		self.quantityField.placeholder = @"Quantity";
	} else if ([self getQuantity]) {
		[self setTitle:@"Set Quantity"];
		self.metricField.enabled = NO;
		self.metricField.hidden = YES;
		self.quantityField.enabled = YES;
		self.quantityField.hidden = NO;
		self.quantityField.placeholder = @"Quantity";
	} else {
		[self setTitle:@"Set Metric"];
		self.metricField.enabled = NO;
		self.metricField.hidden = YES;
		self.quantityField.enabled = YES;
		self.quantityField.hidden = NO;
		self.quantityField.placeholder = @"Weight/Distance/Other Metric";
	}
	
}



- (void)viewDidAppear:(BOOL)animated
{

	
	[[self quantityField] becomeFirstResponder];
	
}



- (void)save:(id)sender {

	if ([[[self quantityField] text] length] > 0 ) {
		
		NSString *metric = nil;
		NSString *quantity = nil;
		
		if ([self getMetric] && [self getQuantity]) {
			metric = [[self metricField] text];
			quantity = [[self quantityField] text];
		} else if ([self getQuantity]) {
			metric = @"";
			quantity = [[self quantityField] text];
		} else {
			quantity = @"";
			metric = [[self quantityField] text];
		}
		
		// Create a dictionary with the exercise and the quantity and their respective keys
		NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self exercise],quantity,metric,nil] forKeys:[NSArray arrayWithObjects:@"Exercise",@"Quantity",@"Metric",nil]];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"ExerciseSelected" object:nil userInfo:dict];

		[[self navigationController] popToRootViewControllerAnimated:YES];
		
	}

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
