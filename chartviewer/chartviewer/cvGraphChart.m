//
//  cvGraphChartData.m
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvGraphChart.h"
#import "cvConstants.h"

@implementation cvGraphChart

@synthesize xLabel=_xLabel, yLabel=_yLabel, limits=_limits, scale_x=_scale_x, scale_y=_scale_y;
- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self->readyToDraw = NO;
    }
    return self;
}

-(id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        self.title = string;
        self->readyToDraw = NO;
    }
    return self;
}

-(void)setGraphChartWithData:(const cvGraphChartDataPoint[]) data containingDataPoints:(size_t) size
{
    _graphDataPoints = data;
    _nDataPoints = size;
    [self calculateLimits];
    if (data != nil && size>0) {
        self->readyToDraw = YES;
    } else {
        self->readyToDraw = NO;
    }
}

-(void)calculateLimits
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
    self->_limits = limits;
}

-(void) insetWithBorder:(int)borderSize withBounds:(CGRect*)bounds withContext:(CGContextRef)context
{
    CGContextTranslateCTM(context, borderSize, borderSize);
    bounds->size.height -= borderSize*2;
    bounds->size.width  -= borderSize*2;
}

-(void) transformToDomainCoordsWithBounds:(CGRect)bounds withContext:(CGContextRef)context
{
    double domain_x_range = _limits.mx - _limits.lx;
    double domain_y_range = _limits.my - _limits.ly;
    
    if (domain_x_range == 0) {
        domain_x_range = MAX(ABS(_limits.mx), bounds.size.width);
    }
    if (domain_y_range == 0) {
        domain_y_range = MAX(ABS(_limits.my), bounds.size.height);
    }
    
    double scale_x = bounds.size.width / domain_x_range;
    double scale_y = bounds.size.height / domain_y_range;
    
    /*
     Find the translation to get to the x-axis coord Origin of the graph.
     The origin is in domain co-ords (0,0); therefore the distance
     0-_limits.ly is the interval to the left of the origin to the least
     point.  Since there may be no negative least point, we also need
     to consider not having to translate the origin since it is on the
     extreme left.  Therefore MAX(0, 0-_limits.ly) formula is used.
     Lastly, we need to apply a scaling to get the right offset on
     screen for a particular delta in domain coords.
     */
    double tx = MAX(0, 0-_limits.ly) * scale_x;
    
    /*
     Similar logic applies for finding how far down the screen to get
     to the Origin as compared to the maximum y value my.
     */
    double ty = MAX(0, _limits.my) * scale_y;
    
    // Move to origin
    CGContextTranslateCTM(context, tx, ty);
    // Switch y to upwards, leaving x as rightwards.
    CGContextScaleCTM(context, 1, -1);
    
    // Now subsequent drawing can be done in domain co-ordinates so long
    // as they are scaled scale_x, scale_y.  The reason why we don't do
    // this to CTM is because we want the lines of the graph to remain
    // constant thickness
    _scale_x = scale_x;
    _scale_y = scale_y;
}

-(void)drawAxesWithContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,       _scale_x * MIN(0,_limits.lx),   0);
    CGContextAddLineToPoint(context,    _scale_x * MAX(0,_limits.mx),   0);
    CGContextMoveToPoint(context,       0,                              _scale_y * MIN(0,_limits.ly));
    CGContextAddLineToPoint(context,    0,                              _scale_y * MAX(0,_limits.my));
    CGContextStrokePath(context);
    
    double start_x = _scale_x * MIN(0,_limits.lx);
    double end_x = _scale_x * MAX(0,_limits.mx);
    double pace_x = (end_x - start_x) / cvChartGraphIntervals;
    
    CGContextBeginPath(context);
    for (double x_interval = start_x; x_interval < end_x; x_interval += pace_x) {
        CGContextMoveToPoint(context, x_interval, -cvChartGraphMarkerLength);
        CGContextAddLineToPoint(context, x_interval, 0);
    }
    CGContextStrokePath(context);
   
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    for (double x_interval = start_x; x_interval < end_x; x_interval += pace_x) {
        if (ABS(x_interval) < cvChartInsetToAllowGraphLabels) {
            continue; // don't label near the origin because it is by definition 0
        }
        NSString *intervalAsString = [NSString stringWithFormat:@"%f", x_interval];
        CGRect labelArea;
        labelArea.origin.x = x_interval - cvChartInsetToAllowGraphLabels/2;
        labelArea.origin.y = - cvChartGraphMarkerLength - cvChartInsetToAllowGraphLabels;
        labelArea.size.width = cvChartInsetToAllowGraphLabels;
        labelArea.size.height = cvChartInsetToAllowGraphLabels;
        CGContextFillRect(context, labelArea);
        //[intervalAsString drawInRect:labelArea withFont: [UIFont fontWithName:@"Helvetica-Bold" size:1 ] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    }
    CGContextRestoreGState(context);
    
    double start_y = _scale_y * MIN(0,_limits.ly);
    double end_y = _scale_y * MAX(0,_limits.my);
    double pace_y = (end_y - start_y) / cvChartGraphIntervals;
    CGContextBeginPath(context);
    for (double y_interval = start_y; y_interval < end_y; y_interval += pace_y) {
        CGContextMoveToPoint(context, -cvChartGraphMarkerLength, y_interval);
        CGContextAddLineToPoint(context, 0, y_interval);
    }
    CGContextStrokePath(context);
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    for (double y_interval = start_y; y_interval < end_y; y_interval += pace_y) {
        if (ABS(y_interval) < cvChartInsetToAllowGraphLabels) {
            continue; // don't label near the origin because it is by definition 0
        }
        NSString *intervalAsString = [NSString stringWithFormat:@"%f", y_interval];
        CGRect labelArea;
        labelArea.origin.x = 0 - cvChartGraphMarkerLength - cvChartInsetToAllowGraphLabels;
        labelArea.origin.y = y_interval - cvChartInsetToAllowGraphLabels/2;
        labelArea.size.width = cvChartInsetToAllowGraphLabels;
        labelArea.size.height = cvChartInsetToAllowGraphLabels;
        CGContextFillRect(context, labelArea);
        //[intervalAsString drawInRect:labelArea withFont: [UIFont fontWithName:@"Helvetica-Bold" size:1 ] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    }
    CGContextRestoreGState(context);

}

-(void)drawGraphPointsWithContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextBeginPath(context);
    for (int i = 0; i < _nDataPoints; i++) {
        CGRect dataRect;
        dataRect.origin.x = _scale_x * _graphDataPoints[i].x - cvChartGraphDataPointSize;
        dataRect.origin.y = _scale_y * _graphDataPoints[i].y - cvChartGraphDataPointSize;
        dataRect.size.height = 2 * cvChartGraphDataPointSize;
        dataRect.size.width  = 2 * cvChartGraphDataPointSize;
        CGContextFillRect(context, dataRect);
    }
    CGContextRestoreGState(context);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context,   _scale_x * _graphDataPoints[0].x, _scale_y * _graphDataPoints[0].y);
    for (int i = 1; i < _nDataPoints; i++) {
        CGContextAddLineToPoint(context, _scale_x * _graphDataPoints[i].x, _scale_y * _graphDataPoints[i].y);
    }
    CGContextStrokePath(context);
}

-(void) drawChartBodyInContext:(CGContextRef)context withBounds:(CGRect)bounds
{
    if (!self->readyToDraw) {
        return;
    }
    [self insetWithBorder:cvChartInsetToAllowGraphLabels withBounds:&bounds withContext:context];
    [self transformToDomainCoordsWithBounds:bounds withContext:context];
    [self drawAxesWithContext:context];
    [self drawGraphPointsWithContext:context];
    return;
}

@end
