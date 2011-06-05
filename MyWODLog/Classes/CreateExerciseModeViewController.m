//
//  CreateExerciseModeViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateExerciseModeViewController.h"


@implementation CreateExerciseModeViewController

@synthesize mode, name, delegate, managedObjectContext;

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
	
	[self setTitle:@"Add Category"];
    
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



- (void)viewDidAppear:(BOOL)animated
{
    [nameField becomeFirstResponder];
}



- (IBAction)cancel:(id)sender
{
    [self setName:nil];
   // [[self navigationController] popViewControllerAnimated:YES];
	[delegate createExerciseModeViewController:self didFinishWithSave:NO];
}



- (IBAction)save:(id)sender
{
	// Check to see if that name doesn't already exist.
	NSString *queryString = [NSString stringWithFormat:@"name == '%@'", [nameField text]];

	
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"mode" inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:queryString]];
	
	NSError *error = nil; 
	NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if( error || [array count] > 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Category Already Exists" message: @"Error, a category with that name already exists!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		alert = nil;
	} else {
		if( [[nameField text] length] > 0 ) {
			[self setName:[[nameField text] uppercaseString]];
			[[self mode] setName:[[self name] uppercaseString]];
			[delegate createExerciseModeViewController:self didFinishWithSave:YES];
		}
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
	[[self managedObjectContext] release];
	[self setManagedObjectContext:nil];
}


- (void)dealloc {
    [super dealloc];
}


@end
