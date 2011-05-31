//
//  ProgressChartViewController.h
//  MyWODLog
//
//  Created by Derek Dunham on 5/31/11.
//  Copyright 2011 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"WOD.h"
#import "CorePlot-CocoaTouch.h"


@interface ProgressChartViewController : UIViewController {
	
	WOD *wod;
	CPXYGraph *graph;
	
	NSMutableArray *dataForPlot;
}

@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;

@end

	

