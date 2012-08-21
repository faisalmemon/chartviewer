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
#import "cvBarChart.h"

@interface cvModel : NSObject {
    NSArray *_graphCharts;
    NSArray *_pieCharts;
    NSArray *_barCharts;
}

// Returns the 'singleton' instance of this class
+ (id)sharedInstance;

-(void)loadData;

-(int)getNumberOfChartsWithType:(int)chartType;
-(NSArray *)getChartsWithType:(int)chartType;

@end
