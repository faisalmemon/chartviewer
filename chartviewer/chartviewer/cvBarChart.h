//
//  cvBarChart.h
//  chartviewer
//
//  Created by Faisal Memon on 21/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChart.h"
#import "cvConstants.h"
#import "cvBarChartDataPoint.h"

@interface cvBarChart : cvChart {
    NSMutableArray *_data;
    NSString* _xAxisLabel;
    NSString* _yAxisLabel;
}

-(id)initWithTitle:(NSString *)string WithDataSet:(NSMutableArray*)data;
-(void)addLabelAlongAxis:(enum cvAxis)axis WithText:(NSString*)text;
-(void)addYIntervalsEvery:(double)periodicity WithFormat:(NSString*)format_string;

@end
