// 
//  WOD.m
//  MyWODLog
//
//  Created by Matthew Dalrymple on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WOD.h"

#import "EEXERCISE.h"
#import "RROUND.h"
#import "SCORE.h"

@implementation WOD

/*
 #define WOD_SCORE_TYPE_NONE			0
 #define WOD_SCORE_TYPE_TIME			1
 #define WOD_SCORE_TYPE_REPS			2
 #define WOD_SCORE_TYPE_RNDS			3
 
 #define WOD_SCORE_TYPE_TEXT_NONE	@"None"
 #define WOD_SCORE_TYPE_TEXT_TIME	@"Time"
 #define WOD_SCORE_TYPE_TEXT_REPS	@"Reps"
 #define WOD_SCORE_TYPE_TEXT_RNDS	@"Rounds"*/


+ (NSString*)wodScoreTypeToString:(NSUInteger)wodScoreType {
	
	switch (wodScoreType) {
		case WOD_SCORE_TYPE_NONE:
			return WOD_SCORE_TYPE_TEXT_NONE;
			break;
		case WOD_SCORE_TYPE_TIME:
			return WOD_SCORE_TYPE_TEXT_TIME;
			break;
		case WOD_SCORE_TYPE_REPS:
			return WOD_SCORE_TYPE_TEXT_REPS;
			break;
		case WOD_SCORE_TYPE_RNDS:
			return WOD_SCORE_TYPE_TEXT_RNDS;
			break;
			
		default:
			break;
	}
	
	return @"";
	
}

+ (NSString*)wodTypeToString:(NSUInteger)wodType {
	
	
	switch (wodType) {
		case WOD_TYPE_UNKNOWN:
			return WOD_TYPE_TEXT_UNKNOWN;
			break;
		case WOD_TYPE_TIME:
			return WOD_TYPE_TEXT_TIME;
			break;
		case WOD_TYPE_RFT:
			return WOD_TYPE_TEXT_RFT;
			break;
		case WOD_TYPE_RRFT:
			return WOD_TYPE_TEXT_RRFT;
			break;
		case WOD_TYPE_RFMR:
			return WOD_TYPE_TEXT_RFMR;
			break;
		case WOD_TYPE_AMRAP:
			return WOD_TYPE_TEXT_AMRAP;
			break;
		case WOD_TYPE_EMOTM:
			return WOD_TYPE_TEXT_EMOTM;
			break;
		default:
			break;
	}
	
	return @"";
	
}

@dynamic rounds;
@dynamic notes;
@dynamic timelimit;
@dynamic date_created;
@dynamic score_type;
@dynamic type;
@dynamic name;
@dynamic scores;
@dynamic rrounds;
@dynamic eexercises;

@end
