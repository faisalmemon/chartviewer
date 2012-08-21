//
//  cvBarChart.m
//  chartviewer
//
//  Created by Faisal Memon on 21/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvBarChart.h"

@implementation cvBarChart

-(id)initWithTitle:(NSString *)string WithDataSet:(NSMutableArray*)data
{
    self = [super initWithTitle:string];
    if (self) {
        _data = data;       
    }
    return self;
}

-(void) drawChartBodyInContext:(CGContextRef)context
                    withBounds:(CGRect)bounds
{
    
}

-(void)addLabelAlongAxis:(enum cvAxis)axis WithText:(NSString*)text
{
    if (axis == cvAlongX) {
        _xAxisLabel = text;
    } else {
        _yAxisLabel = text;
    }
}

-(void)addYIntervalsEvery:(double)periodicity WithFormat:(NSString*)format_string
{

}

@end
