//
//  cvGraphChartData.m
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvGraphChartData.h"

@implementation cvGraphChartData

@synthesize xLabel=_xLabel, yLabel=_yLabel;
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

-(void)setGraphChartWithData:(const cvGraphChartDataPoint[]) data containingDataPoints:(size_t) size
{
    _graphDataPoints = data;
    _nDataPoints = size;
}

-(graphChartDataLimits)getLimits
{
    graphChartDataLimits limits;
    limits.lx=limits.ly=limits.mx=limits.my=0;
    bool firstTime = YES;
    for (int i = 0; i < _nDataPoints; i++) {
        if (firstTime) {
            firstTime = NO;
            limits.lx = _graphDataPoints[0].x;
            limits.mx = limits.lx;
            limits.ly = _graphDataPoints[0].y;
            limits.my = limits.ly;
            continue;
        } else {
            if (_graphDataPoints[i].x < limits.lx)
                limits.lx = _graphDataPoints[i].x;
            if (_graphDataPoints[i].y < limits.ly)
                limits.ly = _graphDataPoints[i].y;
            if (_graphDataPoints[i].x > limits.mx)
                limits.mx = _graphDataPoints[i].x;
            if (_graphDataPoints[i].y > limits.my)
                limits.my = _graphDataPoints[i].y;
        }
        
    }
    return limits;
}

@end
