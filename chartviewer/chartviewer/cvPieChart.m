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
@synthesize units=_units;

-(id)initWithData:(NSMutableArray *)pieChartData InFormatUnits:(NSString*)units  WithTitle:(NSString*)title {
    if (pieChartData == nil || title == nil || units == nil) {
        return nil;
    }
    self = [super initWithTitle:title];
    if (self) {
        self->_pieChartData = pieChartData;
        self->_units = units;
        BOOL result = [self calculateDerivedData];
        if (!result)
            return nil;
    }
    return self;
}

-(BOOL)calculateDerivedData
{
    BOOL result = [self calculateTotal];
    if (!result) return NO;
    [self calculatePresentationData];
    return YES;
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

-(void)calculatePresentationData {
    double lastAngleOfSlice = 0;
    double newAngleForSlice = 0;
    int item = 0;
    for (cvPieChartDataPoint *data in _pieChartData) {
        double angle = [self angleFromWeight:[data weight]];
        newAngleForSlice = lastAngleOfSlice + angle;
        [data setSliceAnglesStarting:lastAngleOfSlice Ending:newAngleForSlice];
        double labelAngle = lastAngleOfSlice + 0.5 * angle;
        [data setLabelAngle:labelAngle];
        struct cv_rgba_t c = cvGetContrastingColor(item);
        CGFloat r,g,b,a;
        r = c.r/255.0;
        g = c.g/255.0;
        b = c.b/255.0;
        a = c.a/255.0;
        UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:a];
        [data setColor:color];
        lastAngleOfSlice = newAngleForSlice;
        item++;
    }
}

-(void)drawPieChartSegmentsInContext:(CGContextRef)context At:(CGPoint)center WithSize:(double)radius
{
    CGContextSaveGState(context);
    
    /* Change to cartesian co-ords centered on the center of the pie chart, y goes up, x goes right */
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextScaleCTM(context, 1, -1);
    
    for (cvPieChartDataPoint *data in _pieChartData) {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0, 0);
        CGContextSetRGBFillColor(context, [data red], [data green], [data blue], [data alpha]);
        CGContextAddArc(context, 0, 0, radius, [data startingAngle], [data endingAngle], 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    CGContextRestoreGState(context);
}

-(void)drawPieChartLabelsInContext:(CGContextRef)context At:(CGPoint)center WithSize:(double)radius
{
    CGContextSaveGState(context);
    const double labelDistance = radius + cvPieChartRadialDistance;
    /* Change to cartesian co-ords centered on the center of the pie chart, y goes up, x goes right */
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextScaleCTM(context, 1, -1);
    for (cvPieChartDataPoint *data in _pieChartData) {
        CGPoint justOutsideCircle = {
            cos([data labelAngle]) * labelDistance,
            sin([data labelAngle]) * labelDistance
        };
        NSString *labelWithPercent = [NSString stringWithFormat:@"%@ %3.0f %%", [data label], 100 * [data weight]/_totalWeight];
        /* Put right side segment labels rightwards, and left side segments shifted leftwards; FromPoint vs EndPoint */
        if (radiansInLeftSemicircle([data labelAngle])) {
            [self drawLabelWithContext:context
                              WithText:labelWithPercent
                          WithFontName:cvChartIntervalLabelFont
                          WithFontSize:cvChartIntervalLabelFontSize
                  WithCharacterSpacing:cvChartIntervalLabelFontSpacing
                              EndPoint:justOutsideCircle
                           InDirection:0];
        } else {
            [self drawLabelWithContext:context
                              WithText:labelWithPercent
                          WithFontName:cvChartIntervalLabelFont
                          WithFontSize:cvChartIntervalLabelFontSize
                  WithCharacterSpacing:cvChartIntervalLabelFontSpacing
                             FromPoint:justOutsideCircle
                           InDirection:0];
        }
    }
    CGContextRestoreGState(context);
}

-(void)drawKeyBoxInContext:(CGContextRef)context
                       Red:(CGFloat)red
                     Green:(CGFloat)green
                      Blue:(CGFloat)blue
                     Alpha:(CGFloat)alpha
                WithExtent:(CGRect)extent
{
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextAddRect(context, extent);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}

-(void)drawPieChartTableInContext:(CGContextRef)context WithinBounds:(CGRect)dataTableArea
{
    CGContextSaveGState(context);
    
    /* Switch to cartesian co-ords based on the bottom left of key table area */
    CGContextTranslateCTM(context, dataTableArea.origin.x, dataTableArea.origin.y + dataTableArea.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextMoveToPoint(context, 0, 0);
    
    CGRect extentToDrawTable = {
        0, dataTableArea.size.height - cvChartDataTableYPace * (1+[_pieChartData count]),
        dataTableArea.size.width, cvChartDataTableYPace * (1+[_pieChartData count])
    };
    CGContextBeginPath(context);
    CGContextAddRect(context, extentToDrawTable);
    CGContextStrokePath(context);
    
    double iteration = 1;
    double widthLongestLabel = 0;
    for (cvPieChartDataPoint *data in _pieChartData) {
        
        CGRect keyBox = {
            cvChartInsetToAllowGraphLabels,
            dataTableArea.size.height - iteration*cvChartDataTableYPace,
            cvChartKeyBoxSize,
            cvChartKeyBoxSize
        };
        [self drawKeyBoxInContext:context
                              Red:[data red]
                            Green:[data green]
                             Blue:[data blue]
                            Alpha:[data alpha]
                       WithExtent:keyBox];
        CGPoint startPoint = {
            cvChartInsetToAllowGraphLabels + cvChartKeyBoxSize*2,
            keyBox.origin.y
        };
        double lengthOfLabel =
        [self drawLabelWithContext:context
                          WithText:[data label]
                      WithFontName:cvChartIntervalLabelFont
                      WithFontSize:cvChartIntervalLabelFontSize
              WithCharacterSpacing:cvChartIntervalLabelFontSpacing
                         FromPoint:startPoint
                       InDirection:0];
        if (lengthOfLabel > widthLongestLabel) {
            widthLongestLabel = lengthOfLabel;
        }
        iteration++;
    }
    iteration = 1;
    for (cvPieChartDataPoint *data in _pieChartData) {
        CGPoint startPoint = {
            cvChartInsetToAllowGraphLabels + cvChartKeyBoxSize*2 + widthLongestLabel + cvChartInsetToAllowGraphLabels,
            dataTableArea.size.height - iteration*cvChartDataTableYPace
        };
        [self drawLabelWithContext:context
                          WithText:[NSString stringWithFormat:[self units], [data weight]]
                      WithFontName:cvChartIntervalLabelFont
                      WithFontSize:cvChartIntervalLabelFontSize
              WithCharacterSpacing:cvChartIntervalLabelFontSpacing
                         FromPoint:startPoint
                       InDirection:0];
        iteration++;
    }
 
    CGContextRestoreGState(context);
}

-(void)drawPieChartInContext:(CGContextRef)context At:(CGPoint)center WithSize:(double)radius
{
    [self drawPieChartSegmentsInContext:context At:center WithSize:radius];
    [self drawPieChartLabelsInContext:context At:center WithSize:radius];

}

/*
 Draw the pie chart in portrait orientation.  In this orientation, we show a large pie chart, without a key table.
 */
-(void) drawChartPortraitInContext:(CGContextRef)context withBounds:(CGRect) bounds
{
    CGPoint center = {bounds.size.width*0.5, bounds.size.width*0.5};
    double radius = bounds.size.width*0.2;
    [self drawPieChartInContext:context At:(CGPoint)center WithSize:radius];
}

/*
 Draw the pie chart in landscape orientation.  In this orientation we show a smaller pie chart, so we can fit a table next to it.
 */
-(void) drawChartLandscapeInContext:(CGContextRef)context withBounds:(CGRect)bounds
{
    CGPoint center = {bounds.size.height*0.5, bounds.size.height*0.5};
    double radius = bounds.size.height*0.5*0.3;
    [self drawPieChartInContext:context At:(CGPoint)center WithSize:radius];
    CGRect dataTableArea;
    dataTableArea.origin.x = center.x + radius + cvPieChartDataTableXOffset;
    dataTableArea.origin.y = cvPieChartDataTableYOffset;
    dataTableArea.size.width = bounds.size.width - dataTableArea.origin.x - cvPieChartDataTableXGutter;
    dataTableArea.size.height = bounds.size.height - dataTableArea.origin.y - cvPieChartDataTableYGutter;
    
    [self drawPieChartTableInContext:context WithinBounds:dataTableArea];
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
