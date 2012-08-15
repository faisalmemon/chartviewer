//
//  cvGraphChartData.m
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvGraphChartData.h"

@implementation cvGraphChartData

@synthesize xLabel=_xLabel, yLabel=_yLabel, graphDataPoints=_graphDataPoints;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";
    }
    return self;
}

-(id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        self.title = string;
    }
    return self;
}


-(graphChartDataLimits)getLimits
{
    graphChartDataLimits limits;
    limits.lx=limits.ly=limits.mx=limits.my=0;
    bool firstTime = YES;
    for (cvGraphChartDataPoint *object in _graphDataPoints) {
        if (firstTime) {
            firstTime = NO;
            limits.lx = object.x_value;
            limits.mx = limits.lx;
            limits.ly = object.y_value;
            limits.my = limits.ly;
            continue;
        } else {
            if (object.x_value < limits.lx)
                limits.lx = object.x_value;
            if (object.y_value < limits.ly)
                limits.ly = object.y_value;
            if (object.x_value > limits.mx)
                limits.mx = object.x_value;
            if (object.y_value > limits.my)
                limits.my = object.y_value;
        }
        
    }
    return limits;
}

@end
