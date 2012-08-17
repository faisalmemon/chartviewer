//
//  cvChartView.m
//  chartviewer
//
//  Created by Faisal Memon on 12/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChartView.h"
#import "cvConstants.h"
#import "cvChart.h"

@implementation cvChartView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawGraphInContext:(CGContextRef)context withBounds:(CGRect)bounds {
    CGContextSaveGState(context);

    if (self->chartSelectionHandler == nil) {
        return;
    }
    if (![chartSelectionHandler cvIsAnyChartSelected]) {
        return;
    }
    cvChart* selectedChart = [chartSelectionHandler cvGetSelectedChart];
    [selectedChart drawTitleInContext:context withBounds:&bounds updatingBounds:YES updatingContext:YES];
    [selectedChart drawChartBodyInContext:context withBounds:bounds];
    
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)clip
{
    CGRect bounds = [self bounds];

	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextSetAllowsAntialiasing(context, true);
        
	[self drawGraphInContext:context withBounds:bounds];
	
    CGContextRestoreGState(context);
}


- (void)adjustToOrientation:(UIInterfaceOrientation)toOrientation
{
    currentOrientation = toOrientation;
    return;
}

- (void)setChartSelectionHandler:(id<cvChartSelectionProtocol>)target
{
    self->chartSelectionHandler = target;
}
@end
