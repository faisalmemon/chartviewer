//
//  cvModel.h
//  chartviewer
//
//  Created by Faisal Memon on 15/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cvConstants.h"
#import "cvGraphChart.h"
#import "cvPieChart.h"

@interface cvModel : NSObject {
    NSArray *graphCharts;
    NSArray *pieCharts;
}

// Returns the 'singleton' instance of this class
+ (id)sharedInstance;

-(void)loadData;

-(int)getNumberOfChartsWithType:(int)chartType;
-(NSArray *)getChartsWithType:(int)chartType;

@end
