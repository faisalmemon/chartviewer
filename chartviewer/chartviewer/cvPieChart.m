//
//  cvPieChart.m
//  chartviewer
//
//  Created by Faisal Memon on 19/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvPieChart.h"

@implementation cvPieChart

-(id)initWithData:(NSMutableArray *)pieChartData WithTitle:(NSString*)title {
    if (pieChartData == nil || title == nil) {
        return nil;
    }
    self = [super initWithTitle:title];
    if (self) {
        self->_pieChartData = pieChartData;
    }
    return self;
}

-(void) drawChartBodyInContext:(CGContextRef)context withBounds:(CGRect)bounds
{
    
}

@end
