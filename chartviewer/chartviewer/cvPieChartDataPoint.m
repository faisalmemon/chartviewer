//
//  cvPieChartDataPoint.m
//  chartviewer
//
//  Created by Faisal Memon on 19/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvPieChartDataPoint.h"
#import "cvConstants.h"

@implementation cvPieChartDataPoint
@synthesize label=_label, weight=_weight, red=_red, green=_green, blue=_blue;

-(id) initWithLabel:(NSString*)label WithWeight:(double)weight {
    if (nil == label || weight < 0)
        return nil;
    
    self = [super init];
    if (self) {
        self->_label = label;
        self->_weight = weight;
    }
    return self;
}

-(void) setSliceAnglesStarting:(double)start_angle Ending:(double)end_angle
{
    self->_startingAngleOfSlice = clampRadiansWithinRange(start_angle);
    self->_endingAngleOfSlice   = clampRadiansWithinRange(end_angle);
}

-(void) setLabelAngle:(double)label_angle
{
    self->_labelAngle = label_angle;
}

-(void) setColor:(UIColor*)color
{
    [color getRed: &_red green: &_green blue: &_blue alpha: &_alpha];
}

@end
