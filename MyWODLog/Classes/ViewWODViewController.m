//
//  ViewWODViewController.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewWODViewController.h"


@implementation ViewWODViewController

@synthesize wod, scoredByLabel, exerciseListLabel;



- (id)init {
	//[self setTitle:@"<WOD Name>"];
	
	return self;
}


- (void)viewDidLoad {
	//Assumes setCurrentWOD is called
	
	if( [[wod score_type] intValue] == WOD_SCORE_TYPE_TIME ) {
		[[self scoredByLabel] setText:@"Time"];
	} else {
		[[self scoredByLabel] setText:@"Number of Repetitions"];
	}
	
	NSString *exerciseList = [[NSString alloc] init];
	
	NSEnumerator *enumer = [[wod exercises] objectEnumerator];
	EXERCISE* e;

	while ((e = (EXERCISE*)[enumer nextObject])) {

		if ([exerciseList length] > 0) {
			exerciseList = [NSString stringWithFormat:@"%@\n\n%@", exerciseList, [e name]];
		} else {
			exerciseList = [e name];
		}
		
	}
	//[myString stringByAppendingString:@" is just a test"];
	[[self exerciseListLabel] setText:exerciseList];
}



- (void)setCurrentWOD:(WOD *)w {

	[self setWod:w];

	[self setTitle:[wod name]];

}



- (void)logScorePressed {
	
	LogScoreViewController* logScore = [[LogScoreViewController alloc] init];

	[[self navigationController] pushViewController:logScore animated:YES];

	[logScore release];
}

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
