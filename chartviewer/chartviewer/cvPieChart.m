//
//  cvPieChart.m
//  chartviewer
//
//  Created by Faisal Memon on 19/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvPieChart.h"
#import "cvConstants.h"

@implementation cvPieChart

-(id)initWithData:(NSMutableArray *)pieChartData WithTitle:(NSString*)title {
    if (pieChartData == nil || title == nil) {
        return nil;
    }
    self = [super initWithTitle:title];
    if (self) {
        self->_pieChartData = pieChartData;
        BOOL result = [self calculateTotal];
        if (!result)
            return nil;
    }
    return self;
}

-(BOOL)calculateTotal
{
    double total = 0;
    for (cvPieChartDataPoint *data in _pieChartData) {
        if ([data weight ] < 0) {
            _totalWeight = 0;
            return NO;
        } else {
            total += [data weight];
        }
    }
    _totalWeight = total;
    return YES;
}

-(double)angleFromWeight:(double)weight {
    double result = 0;
    result = weight / _totalWeight; // _totalWeight cannot be zero due to init which checks this
    result *= 2 * PI;
    return result;
}

-(void)updateFillColorInContext:(CGContextRef)context ForPieAtSliceAngle:(double)angle
{
    if (angle > 2*PI || angle < 0) {
        NSLog(@"Angle out of range [0,2*PI] so ignoring");
        return;
    }
    UIColor *color = [UIColor colorWithHue: angle/(2*PI) saturation: 1 brightness: 1 alpha: 1];
    CGFloat red, green, blue, alpha;
    [color getRed: &red green: &green blue: &blue alpha: &alpha];
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
}

-(void)drawPieChartInContext:(CGContextRef)context At:(CGPoint)center WithSize:(double)radius
{
    CGContextSaveGState(context);
    
    /* Change to cartesian co-ords centered on the center of the pie chart, y goes up, x goes right */
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextScaleCTM(context, 1, -1);
    
    double lastAngleOfSlice = 0;
    for (cvPieChartDataPoint *data in _pieChartData) {
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, 0, 0);
        double newAngleForSlice = lastAngleOfSlice + [self angleFromWeight:[data weight]];
        [self updateFillColorInContext:context ForPieAtSliceAngle:newAngleForSlice];
        CGContextAddArc(context, 0, 0, radius, lastAngleOfSlice, newAngleForSlice, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        lastAngleOfSlice = newAngleForSlice;
    }
    
    CGContextRestoreGState(context);
}

-(void) drawChartPortraitInContext:(CGContextRef)context withBounds:(CGRect) bounds
{
    CGPoint center = {bounds.size.width*0.5, bounds.size.width*0.5*0.75};
    double radius = bounds.size.width*0.75*0.3;
    [self drawPieChartInContext:context At:(CGPoint)center WithSize:radius];
}

-(void) drawChartLandscapeInContext:(CGContextRef)context withBounds:(CGRect)bounds
{
    CGPoint center = {bounds.size.height*0.5, bounds.size.height*0.5*0.75};
    double radius = bounds.size.height*0.75*0.3;
    [self drawPieChartInContext:context At:(CGPoint)center WithSize:radius];
}

-(void) drawChartBodyInContext:(CGContextRef)context withBounds:(CGRect)bounds
{
    if (bounds.size.width > bounds.size.height) {
        [self drawChartLandscapeInContext:context withBounds:bounds];
    } else {
        [self drawChartPortraitInContext:context withBounds:bounds];
    }
}

@end
