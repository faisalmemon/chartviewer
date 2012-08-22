//
//  cvBarChart.m
//  chartviewer
//
//  Created by Faisal Memon on 21/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvBarChart.h"
#import "cvConstants.h"

@implementation cvBarChart

-(id)initWithTitle:(NSString *)string WithDataSet:(NSMutableArray*)data
{
    self = [super initWithTitle:string];
    if (self) {
        _data = data;
    }
    return self;
}

-(void)calculateDerivedDataForContext:(CGContextRef)context
{
    double longestWidthXLabel = 0;
    double minYval = 0, maxYval = 0;
    double length;
    
    /*
     Calculate the longest label on the x axis
     */
    
    for (cvBarChartDataPoint *dp in _data) {
        length = [cvChart labelLengthInContext:context WithText:[dp xLabel] WithFontName:cvChartIntervalLabelFont WithFontSize:cvChartIntervalLabelFontSize WithCharacterSpacing:cvChartIntervalLabelFontSpacing];
        if (length>longestWidthXLabel) {
            longestWidthXLabel = length;
        }
        if ([dp yValue] < minYval) {
            minYval = [dp yValue];
        }
        if ([dp yValue] > maxYval) {
            maxYval = [dp yValue];
        }
    }
    _maxLabelLengthX = longestWidthXLabel;

    
    /*
     Calculate the extreme values of y and adjust to ensure the origin always is present
     */
    
    _minYvalue = MIN(0, minYval);
    _maxYvalue = MAX(0, maxYval);
    
    
    /*
     If the user has specified interval labels on the y axis, calculate the widest on-screen label.
     */
    if (_yIntervalsDefined) {
        
        double longestWidthYLabel = 0;
        for (double interval = -_yIntervalPeriodicity; interval >= minYval; interval -= _yIntervalPeriodicity) {
            NSString *labelOnYaxis = [NSString
                                      stringWithFormat:_yIntervalFormat,
                                      interval];
            length = [cvChart labelLengthInContext:context WithText:labelOnYaxis WithFontName:cvChartIntervalLabelFont WithFontSize:cvChartIntervalLabelFontSize WithCharacterSpacing:cvChartIntervalLabelFontSpacing];
            if (length>longestWidthYLabel) {
                longestWidthYLabel = length;
            }
            
        }
        for (double interval = _yIntervalPeriodicity; interval <= maxYval; interval += _yIntervalPeriodicity) {
            NSString *labelOnYaxis = [NSString
                                      stringWithFormat:_yIntervalFormat,
                                      interval];
            length = [cvChart labelLengthInContext:context WithText:labelOnYaxis WithFontName:cvChartIntervalLabelFont WithFontSize:cvChartIntervalLabelFontSize WithCharacterSpacing:cvChartIntervalLabelFontSpacing];
            if (length>longestWidthYLabel) {
                longestWidthYLabel = length;
            }
            
        }
        _maxLabelLengthY = longestWidthYLabel;
    }
    
    /*
     If there is a y axis label, calculate its length.
     */
    if (nil != _yAxisLabel) {
        _yAxisLabelLength = [cvChart labelLengthInContext:context WithText:_yAxisLabel WithFontName:cvChartLabelFont WithFontSize:cvChartLabelFontSize WithCharacterSpacing:cvChartLabelFontSpacing];
    }
    return;
}

/*
 Draw the Y axis label.  If update is YES, the co-ords are y flipped and re-origined to the bottom left, and then shifted to the right to allow the space reserved for a Y axis label, and the bounds shrunk on the right by the same amount.  If there is no Y axis label, the reserved space for it is left blank.
 */
-(void) drawYaxisLabelInContext:(CGContextRef)context
                     WithBounds:(CGRect*)bounds
    AllowContextAndBoundsUpdate:(BOOL)update
{
    if (!update) {
        CGContextSaveGState(context);
    }
    CGContextTranslateCTM(context, 0, bounds->size.height);
    CGContextScaleCTM(context, 1, -1); // so we can print text without y axis mirror
    if (nil != _yAxisLabel) {
        CGPoint start = {cvBarChartLabelOffset, bounds->size.height*0.5 - _yAxisLabelLength*0.5};
        [self drawLabelWithContext:context WithText:_yAxisLabel WithFontName:cvChartLabelFont WithFontSize:cvChartLabelFontSize WithCharacterSpacing:cvChartLabelFontSpacing FromPoint:start InDirection:radians(90)];
    }
    CGContextTranslateCTM(context, cvBarChartLabelOffset, 0);
    if (update) {
        bounds->size.width -= cvBarChartLabelOffset;
    }
    
    if (!update) {
        CGContextRestoreGState(context);
    }
}

-(void) drawChartBodyInContext:(CGContextRef)context
                    withBounds:(CGRect)bounds
{
    [self calculateDerivedDataForContext:context];
    [self drawYaxisLabelInContext:context WithBounds:&bounds AllowContextAndBoundsUpdate:YES];
}

-(void)addLabelAlongAxis:(enum cvAxis)axis WithText:(NSString*)text
{
    if (axis == cvAlongX) {
        _xAxisLabel = text;
    } else {
        _yAxisLabel = text;
    }
}

-(void)addYIntervalsEvery:(double)periodicity WithFormat:(NSString*)format_string
{
    self->_yIntervalFormat = format_string;
    self->_yIntervalPeriodicity = periodicity;
    self->_yIntervalsDefined = YES;
}

@end
