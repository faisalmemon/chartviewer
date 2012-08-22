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

-(void)calculateScalingForContext:(CGContextRef)context InBounds:(CGRect)bounds
{
    double yValueRange = _maxYvalue - _minYvalue;
    if (yValueRange != 0) {
        _scaleY =bounds.size.height / yValueRange;
    } else {
        _scaleY = 0;
    }
    int numberOfXitems = [_data count];
    if (numberOfXitems < 1) {
        _scaleX = 0;
    } else {
        _scaleX = bounds.size.width / numberOfXitems;
    }
}

-(void) updateYCoordGeometryInContext:(CGContextRef)contextToUpdate WithBounds:(CGRect)bounds
{
    CGContextTranslateCTM(contextToUpdate, 0, bounds.size.height);
    CGContextScaleCTM(contextToUpdate, 1, -1); // so we can print text without y axis mirror
}


/*
 Draw the Y axis label.
 */
-(void) drawYaxisLabelInContext:(CGContextRef)context
                     WithBounds:(CGRect)bounds
{
    if (_yAxisLabel) {
        CGPoint start = {-_maxLabelLengthY - cvBarChartIntervalMarker - cvBarChartLabelDrop, _scaleY * (_minYvalue + _maxYvalue)/2.0 - 0.5*_yAxisLabelLength};
        [self drawLabelWithContext:context WithText:_yAxisLabel WithFontName:cvChartLabelFont WithFontSize:cvChartLabelFontSize WithCharacterSpacing:cvChartLabelFontSpacing FromPoint:start InDirection:radians(90)];
    }
}

/*
 Draw the Y axis.  Assumes supplied context and bounds has origin bottom left, x rightward, y upward.  If update is YES, updates the context to have the origin at the baseline of the x axis of the bar chart, shifted rightwards so as to allow y title, interval markers and y interval labels to be draw to its left (in negative x co-ords), and adjusting bounds to shrink the width accordingly.
 */
-(void) drawYaxisInContext:(CGContextRef)context WithBounds:(CGRect*)bounds AllowContextAndBoundsUpdate:(BOOL)update
{
    CGRect shrunkBounds = *bounds;
    if (!update) {
        CGContextSaveGState(context);
    }
    CGContextTranslateCTM(context, _maxLabelLengthY + cvBarChartLabelOffset + cvBarChartIntervalMarker, _maxLabelLengthX + cvBarChartIntervalMarker);
    shrunkBounds.size.width -= _maxLabelLengthY + cvBarChartLabelOffset + cvBarChartIntervalMarker;
    shrunkBounds.size.height -= _maxLabelLengthX + cvBarChartIntervalMarker;
    [self calculateScalingForContext:context InBounds:shrunkBounds];
    
    CGContextTranslateCTM(context, 0, _minYvalue * -1 * _scaleY);
    
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, _maxYvalue*_scaleY);
    CGContextAddLineToPoint(context, 0, _minYvalue*_scaleY);
    CGContextStrokePath(context);
    
    if (update) {
        *bounds = shrunkBounds;
    }
    if (!update) {
        CGContextRestoreGState(context);
    }
}

-(void) drawYaxisIntervalMarkerInContext:(CGContextRef)context WithBounds:(CGRect)bounds AtYaxis:(double)yaxisPosition
{
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, yaxisPosition * _scaleY);
    CGContextAddLineToPoint(context, -cvBarChartIntervalMarker, yaxisPosition * _scaleY);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void) drawYaxisLabelsInContext:(CGContextRef)context WithBounds:(CGRect)bounds
{
    if (_yIntervalPeriodicity == 0) {
        return;
    }
        
    CGContextSaveGState(context);
    for (double interval = 0; interval >= _minYvalue; interval -= _yIntervalPeriodicity) {
        NSString *labelOnYaxis = [NSString
                                  stringWithFormat:_yIntervalFormat,
                                  interval];
        CGPoint endp = {-cvBarChartIntervalMarker, interval*_scaleY};
        [self drawLabelWithContext:context WithText:labelOnYaxis WithFontName:cvChartIntervalLabelFont WithFontSize:cvChartIntervalLabelFontSize WithCharacterSpacing:cvChartIntervalLabelFontSpacing EndPoint:endp InDirection:0];
        [self drawYaxisIntervalMarkerInContext:context WithBounds:bounds AtYaxis:interval];
        
    }
    for (double interval = _yIntervalPeriodicity; interval <= _maxYvalue; interval += _yIntervalPeriodicity) {
        NSString *labelOnYaxis = [NSString
                                  stringWithFormat:_yIntervalFormat,
                                  interval];
        CGPoint endp = {-cvBarChartIntervalMarker, interval*_scaleY};
        [self drawLabelWithContext:context WithText:labelOnYaxis WithFontName:cvChartIntervalLabelFont WithFontSize:cvChartIntervalLabelFontSize WithCharacterSpacing:cvChartIntervalLabelFontSpacing EndPoint:endp InDirection:0];
        [self drawYaxisIntervalMarkerInContext:context WithBounds:bounds AtYaxis:interval];
    }

    CGContextRestoreGState(context);
}

-(void) drawChartBodyInContext:(CGContextRef)context
                    withBounds:(CGRect)bounds
{
    [self calculateDerivedDataForContext:context];
    [self updateYCoordGeometryInContext:context WithBounds:bounds];
    [self drawYaxisInContext:context WithBounds:&bounds AllowContextAndBoundsUpdate:YES];
    [self drawYaxisLabelInContext:context WithBounds:bounds];
    [self drawYaxisLabelsInContext:context WithBounds:bounds];
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
