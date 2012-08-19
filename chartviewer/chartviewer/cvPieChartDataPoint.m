//
//  cvPieChartDataPoint.m
//  chartviewer
//
//  Created by Faisal Memon on 19/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvPieChartDataPoint.h"

@implementation cvPieChartDataPoint
@synthesize label=_label, weight=_weight;

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


@end
