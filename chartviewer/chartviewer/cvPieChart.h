//
//  cvPieChart.h
//  chartviewer
//
//  Created by Faisal Memon on 19/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChart.h"
#import "cvPieChartDataPoint.h"

@interface cvPieChart : cvChart {
    NSMutableArray *_pieChartData;
    NSString *_units;
    double _totalWeight;
}

@property(readonly) NSString* units;

/*
 Initialize with data.  InFormatUnits refers to the format string together with units.  For example
        %3.0f %% means that data table entries will print like "Butter 35 %"
 */
-(id)initWithData:(NSMutableArray *)pieChartData InFormatUnits:(NSString*)units WithTitle:(NSString*)title;

@end
