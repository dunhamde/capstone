//
//  ProgressChartViewController.h
//  MyWODLog
//
//  Created by Derek Dunham on 5/31/11.
//  Copyright 2011 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"WOD.h"
#import "SCORE.h"
#import "MyWODLogAppDelegate.h"
#import "CorePlot-CocoaTouch.h"

@interface ProgressChartViewController : UIViewController <CPPlotDataSource> {
	
	NSFetchedResultsController	*fetchedResultsController;
	NSManagedObjectContext		*managedObjectContext;
	
	WOD *wod;
	CPXYGraph *graph;
	NSMutableArray *plotData;
}
@property (nonatomic, retain) NSFetchedResultsController	*fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext		*managedObjectContext;
@property (nonatomic, retain) WOD		*wod;


@property(readwrite, retain, nonatomic) NSMutableArray *plotData;

@end

	

