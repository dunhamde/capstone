//*****************************************************************************************
//CreateWODViewController.h snippet
//*****************************************************************************************

@interface CreateWODViewController : UIViewController  <UITextFieldDelegate,UITableViewDelegate> {
	
	id <CreateWODViewControllerDelegate> delegate;
	NSManagedObjectContext *managedObjectContext;
	
	// UI Elements:
	UIBarButtonItem *saveButton;
	
	IBOutlet UISwitch *scoreSwitch;
	IBOutlet UITableView *table;
	
	// WOD Attributes:
	NSMutableArray*	wodExerciseArray;
	NSString*		wodName;
	int				wodType;
	NSString*		wodNotes;
	NSString*		wodTimeLimit;
	NSString*		wodNumRounds;
	NSMutableArray*	wodRepRounds;
	int				wodScoreType;
	
	// Flags:
	BOOL readyToSave;
	
	BOOL quantifyExercises;
	BOOL showTimeLimit;
	BOOL showNumRounds;
	BOOL showRepRounds;
	
}

// Create setter/getters for our class members:
@property (nonatomic, assign) id <CreateWODViewControllerDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UITableView *table;


@property (nonatomic, retain) NSMutableArray*	wodExerciseArray;
@property (nonatomic, retain) NSString*			wodName;
@property (nonatomic, assign) int				wodType;
@property (nonatomic, retain) NSString*			wodNotes;
@property (nonatomic, retain) NSString*			wodTimeLimit;
@property (nonatomic, retain) NSString*			wodNumRounds;
@property (nonatomic, retain) NSMutableArray*	wodRepRounds;
@property (nonatomic, assign) int				wodScoreType;

@property (nonatomic, assign) BOOL				readyToSave;
@property (nonatomic, assign) BOOL				quantifyExercises;
@property (nonatomic, assign) BOOL				showTimeLimit;
@property (nonatomic, assign) BOOL				showNumRounds;
@property (nonatomic, assign) BOOL				showRepRounds;


// Notifications:
- (void)exerciseSelectedNote:(NSNotification*)saveNotification;
- (void)nameChangedNote:(NSNotification*)saveNotification;
- (void)notesChangedNote:(NSNotification*)saveNotification;
- (void)typeChangedNote:(NSNotification*)saveNotification;
- (void)timeLimitChangedNote:(NSNotification*)saveNotification;
- (void)numRoundsChangedNote:(NSNotification*)saveNotification;
- (void)repRoundsChangedNote:(NSNotification*)saveNotification;

// Misc Methods:
- (void)evaluateSaveReadiness;

// Button Methods:
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

//*****************************************************************************************
//CreateWODViewController.m snippet
//*****************************************************************************************

#import "CreateWODViewController.h"

@implementation CreateWODViewController

@synthesize managedObjectContext, delegate, saveButton, table;
@synthesize readyToSave, quantifyExercises, showNumRounds, showRepRounds, showTimeLimit;
@synthesize wodName, wodExerciseArray, wodNotes, wodType, wodTimeLimit, wodNumRounds, wodRepRounds, wodScoreType;

// Called the first time this view is created.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[self setTitle:@"Create WOD"];
	
	// Configure the save and cancel buttons.
	[self setSaveButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)]];
	[[self saveButton] setEnabled:YES];
	[[self navigationItem] setRightBarButtonItem:[self saveButton]];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[cancelButton release];
	
	// Default flag values:
	[self setShowNumRounds:NO];
	[self setShowRepRounds:NO];
	[self setShowTimeLimit:NO];
	[self setQuantifyExercises:YES];
	
	[self evaluateSaveReadiness];
	
}

// Called each time the view appears on the screen
- (void)viewWillAppear:(BOOL)animated {
	
	// Register for all notifications
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	
	[dnc addObserver:self selector:@selector(exerciseSelectedNote:) name:@"ExerciseSelected" object:nil];
	[dnc addObserver:self selector:@selector(nameChangedNote:) name:@"EditSent" object:nil];
	[dnc addObserver:self selector:@selector(notesChangedNote:) name:@"NotesSent" object:nil];
	[dnc addObserver:self selector:@selector(typeChangedNote:) name:@"TypeSent" object:nil];
	[dnc addObserver:self selector:@selector(timeLimitChangedNote:) name:@"TimeLimitSent" object:nil];
	[dnc addObserver:self selector:@selector(numRoundsChangedNote:) name:@"NumRoundsSent" object:nil];
	[dnc addObserver:self selector:@selector(repRoundsChangedNote:) name:@"RepRoundsSent" object:nil];
	
}


#pragma mark -
#pragma mark Notifications

// Called when the "ExerciseSelected" notification is sent. 
// This notification is sent when the user has selected an exercise to be added to the WOD
- (void)exerciseSelectedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'Exercises' and refresh the table
	EXERCISE *e = [dict objectForKey:@"Exercise"];
	[[self wodExerciseArray] addObject:e];
	[[self table] reloadData];
	
	// Remove the notifcation
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"ExerciseSelected" object:nil];
	
	// See if this change will allow us to save
	[self evaluateSaveReadiness];
	
}

// Called when the "EditSent" notification is sent. 
// This notification is sent when the user has modified the name of the WOD
- (void)nameChangedNote:(NSNotification*)saveNotification {
	
	NSDictionary *dict = [saveNotification userInfo];
	
	// Update 'WOD Name' and refresh the table
	[self setWodName:[dict objectForKey:@"Text"]];
	[[self table] reloadData];
	
	// Remove the notification
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:@"EditSent" object:nil];
	
	// See if this change will allow us to save
	[self evaluateSaveReadiness];
	
}

#pragma mark -
#pragma mark Misc. Methods

// Called whenever a notification is handled. Checks that there has been enough user input for the WOD to save
- (void)evaluateSaveReadiness {
	
	BOOL activate = NO;
	
	// Should the user be able to press 'Save' yet?
	if ( [self wodName] != nil && [[self wodName] length] > 0 ) {
		if ([self wodType] > 0) {
			
			activate = YES;
			
		}
	}
	
	// Switch On/Off save button depending on conditions:
	if (activate) {
		// Activate save button
		[[self saveButton] setEnabled:YES];
		[self setReadyToSave:YES];
	} else {
		// Grey out (deactivate) the save button
		[[self saveButton] setEnabled:NO];
		[self setReadyToSave:NO];
	}
}


#pragma mark -
#pragma mark Table View Controller stuff


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Get the cell's unique identifier from the indexPath.
	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];		
	NSString *cellIdentifier = [cell reuseIdentifier];
	
	// Case 'WOD Name':
	if( [cellIdentifier isEqualToString:@"NameCell"] ) {
		
		EditViewController *controller = [[EditViewController alloc] init];
		
		// Set the EditViewController's view specifications and then display the view 
		[controller setTitleName:@"Name"];
		[controller setNotificationName:@"EditSent"];
		[controller setEditType:EDIT_TYPE_NORMAL];
		[controller setDefaultText:[self wodName]];
		[[self navigationController] pushViewController:controller animated:YES];
		
		[controller release];
		
	}
	// Case 'Add Exercise...':
	else if( [cellIdentifier isEqualToString:@"AddCell"] ) {
		
		ViewExerciseModesViewController* controller = [[ViewExerciseModesViewController alloc] init];
		[controller setManagedObjectContext:[self managedObjectContext]];
		
		// Set up back button
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		[[self navigationItem] setBackBarButtonItem:backButton];
		[backButton release];
		
		[[self navigationController] pushViewController:controller animated:YES];
		
		[controller release];
		
	}

}

@end
