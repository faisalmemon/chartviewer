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
    
    BOOL _yIntervalsDefined;
    NSString* _yIntervalFormat;
    double _yIntervalPeriodicity;
    
    double _minYvalue;
    double _maxYvalue;
    double _maxLabelLengthX; // from *data we find the longest text length on-screen
    double _maxLabelLengthY; // from _yIntervalFormat/Periodicity we find the longest text length on-screen
    double _yAxisLabelLength; // on-screen length of the y axis label, if set
}

-(id)initWithTitle:(NSString *)string WithDataSet:(NSMutableArray*)data;
-(void)addLabelAlongAxis:(enum cvAxis)axis WithText:(NSString*)text;
-(void)addYIntervalsEvery:(double)periodicity WithFormat:(NSString*)format_string;

@end
