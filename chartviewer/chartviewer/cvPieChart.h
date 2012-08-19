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
}

-(id)initWithData:(NSMutableArray *)pieChartData WithTitle:(NSString*)title;

@end
