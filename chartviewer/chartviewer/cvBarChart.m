//
//  cvBarChart.m
//  chartviewer
//
//  Created by Faisal Memon on 21/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvBarChart.h"

@implementation cvBarChart

-(id)initWithTitle:(NSString *)string {
    self = [super init];
    if (self) {
        self.title = string;
               
    }
    return self;
}

-(void)addDataSet:(NSMutableArray*)data
{
    self->_data = data;
}

-(void)addLabelAlongAxis:(enum cvAxis)axis WithText:(NSString*)text
{
    if (axis == cvAlongX) {
        _xAxisLabel = text;
    } else {
        _yAxisLabel = text;
    }
}

-(void) drawChartBodyInContext:(CGContextRef)context
                    withBounds:(CGRect)bounds
{
    
}

@end
