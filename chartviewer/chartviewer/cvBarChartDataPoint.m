//
//  cvBarChartDataPoint.m
//  chartviewer
//
//  Created by Faisal Memon on 21/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvBarChartDataPoint.h"

@implementation cvBarChartDataPoint

-(id) initWithLabel:(NSString*)label WithValue:(double)value
{
    if (nil == label) {
        return nil;
    }
    self = [super init];
    if (self) {
        self->_xLabel = label;
        self->_yValue = value;
    }
    return self;
}
@end

