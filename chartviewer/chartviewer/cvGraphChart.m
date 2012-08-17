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

@synthesize xLabel=_xLabel, yLabel=_yLabel, limits=_limits, scale_x=_scale_x, scale_y=_scale_y,
                xIntervalFormat=_xIntervalFormat, yIntervalFormat=_yIntervalFormat;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self->readyToDraw = NO;
        self->_xIntervalFormat = @"%3f";
        self->_yIntervalFormat = @"%3f";
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
WithIntervalStepsX:(double)steps_x WithIntervalStepsY:(double)steps_y WithXLabel:(NSString*)label_x WithXLabelAlignedTo:(double)offset_x_label WithYLabel:(NSString*)label_y WithYLabelAlignedTo:(double)offset_y_label
{
    _graphDataPoints = data;
    _nDataPoints = size;
    _stepper_x = steps_x;
    _stepper_y = steps_y;
    _xLabel = label_x;
    _yLabel = label_y;
    _offsetXLabel = offset_x_label;
    _offsetYLabel = offset_y_label;
    
    [self calculateLimits];
    if (data != nil && size>0 && _xLabel != nil && _yLabel != nil) {
        readyToDraw = YES;
    } else {
        readyToDraw = NO;
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

-(void)drawGraphLabelWithContext:(CGContextRef)context WithText:(NSString*)text WithBounds:(CGRect)bounds
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
    CGContextTranslateCTM(context, cvChartGraphMarkerLength, cvChartGraphMarkerLength);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextSelectFont (context,
                         "Helvetica",
                         0.5,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (context, 0.1);
    CGContextSetTextDrawingMode (context, kCGTextFillStroke);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

    CGContextShowTextAtPoint (context, 0, 0, text.UTF8String, strlen(text.UTF8String));

    CGContextRestoreGState(context);
}

-(void)drawAxisLabelWithContext:(CGContextRef)context WithText:(NSString*) text FromPoint:(CGPoint)from InDirection:(CGFloat)direction
{
    CGContextSaveGState(context);
    CGContextSelectFont (context,
                         "Helvetica",
                         1,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (context, 0.2);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextTranslateCTM(context, from.x, from.y);
    CGContextMoveToPoint(context, 0, 0);
    CGContextRotateCTM(context, direction);
    CGContextScaleCTM(context, 1, -1); // for text system, to avoid mirror-effect writing
    CGContextSetTextDrawingMode (context, kCGTextFillStroke);
    CGContextShowTextAtPoint (context, 0, 0, text.UTF8String, strlen(text.UTF8String));
    CGContextRestoreGState(context);
}

-(void)drawGraphLabelWithContext:(CGContextRef)context WithText:(NSString*)text
WithTip:(CGPoint)tip InDirection:(CGFloat)direction
{
    CGContextSaveGState(context);
    CGContextSelectFont (context,
                         "Helvetica",
                         0.5,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (context, 0.1);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    
    /*
     The tip point is the start of the interval marker line that would eventually touch
     one of the axes
     */
    CGContextTranslateCTM(context, tip.x, tip.y);
    CGContextMoveToPoint(context, 0, 0);
    
    /*
     We are now at the place where we want the label to end, oriented in the proper
     direction.  We do an invisible write of the label, find the delta in position
     and then do visible writing from the -delta position to end up at the correct
     end point.
     */
    CGPoint desiredEndPoint = CGContextGetTextPosition(context);
    CGContextSetTextDrawingMode(context, kCGTextInvisible); //  kCGTextInvisible
    CGContextShowText (context, text.UTF8String, strlen(text.UTF8String));
    CGPoint actualEndPoint = CGContextGetTextPosition(context);
    CGFloat widthOfText = actualEndPoint.x - desiredEndPoint.x;
    CGContextMoveToPoint(context, 0, 0);
    
    CGContextRotateCTM(context, direction);
    CGContextTranslateCTM(context, -widthOfText, 0);
    CGContextScaleCTM(context, 1, -1); // for text system, to avoid mirror-effect writing    
    
    CGContextSetTextDrawingMode (context, kCGTextFillStroke);
    CGContextShowTextAtPoint (context, 0, 0, text.UTF8String, strlen(text.UTF8String));

    CGContextRestoreGState(context);

}

-(void)drawXIntervalWithContext:(CGContextRef)context AtX:(int)x
{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, x, -cvChartGraphMarkerLength);
    CGContextAddLineToPoint(context, x, 0);
    CGContextStrokePath(context);
}

-(void)drawYIntervalWithContext:(CGContextRef)context AtY:(int)y
{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, -cvChartGraphMarkerLength, y);
    CGContextAddLineToPoint(context, 0, y);
    CGContextStrokePath(context);
}


-(void)drawAxesWithContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,       _scale_x * MIN(0,_limits.lx),   0);
    CGContextAddLineToPoint(context,    _scale_x * MAX(0,_limits.mx),   0);
    CGContextMoveToPoint(context,       0,                              _scale_y * MIN(0,_limits.ly));
    CGContextAddLineToPoint(context,    0,                              _scale_y * MAX(0,_limits.my));
    CGContextStrokePath(context);
    CGPoint xAxisLabelPos;
    xAxisLabelPos.x = cvChartInsetToAllowGraphLabels;
    xAxisLabelPos.y = - cvChartInsetToAllowGraphLabels;
    [self drawAxisLabelWithContext:context WithText:_xLabel FromPoint:xAxisLabelPos InDirection:radians(0)];
    CGPoint yAxisLabelPos;
    yAxisLabelPos.x = -cvChartInsetToAllowGraphLabels;
    yAxisLabelPos.y = cvChartInsetToAllowGraphLabels;
    [self drawAxisLabelWithContext:context WithText:_yLabel FromPoint:yAxisLabelPos InDirection:radians(90)];

    
    CGFloat angle = radians(90); // writing x labels upwards
    for (double x_interval = -_stepper_x; x_interval >= MIN(0,_limits.lx); x_interval -= _stepper_x)
    {
        double x_onscreen = x_interval * _scale_x;
        [self drawXIntervalWithContext:context AtX:x_onscreen];
        NSString *intervalAsString = [NSString stringWithFormat:self->_xIntervalFormat, x_interval];
        CGPoint tip;
        tip.x = x_onscreen;
        tip.y = -cvChartGraphMarkerLength;
        [self drawGraphLabelWithContext:context WithText:intervalAsString
                                WithTip:tip InDirection:angle];
    }
    
    for (double x_interval = _stepper_x; x_interval <= MAX(0,_limits.mx); x_interval += _stepper_x)
    {
        double x_onscreen = x_interval * _scale_x;
        [self drawXIntervalWithContext:context AtX:x_onscreen];
        NSString *intervalAsString = [NSString stringWithFormat:self->_xIntervalFormat, x_interval];
        CGPoint tip;
        tip.x = x_onscreen;
        tip.y = -cvChartGraphMarkerLength;
        [self drawGraphLabelWithContext:context WithText:intervalAsString
                                WithTip:tip InDirection:angle];
    }

    angle = radians(0); // writing y labels rightwards
    for (double y_interval = -_stepper_y; y_interval >= MIN(0,_limits.ly); y_interval -= _stepper_y)
    {
        double y_onscreen = y_interval * _scale_y;
        [self drawYIntervalWithContext:context AtY:y_onscreen];
        NSString *intervalAsString = [NSString stringWithFormat:self->_yIntervalFormat, y_interval];
        CGPoint tip;
        tip.x = -cvChartGraphMarkerLength;
        tip.y = y_onscreen;
        [self drawGraphLabelWithContext:context WithText:intervalAsString
                                WithTip:tip InDirection:angle];
    }
    
    for (double y_interval = _stepper_y; y_interval <= MAX(0,_limits.my); y_interval += _stepper_y)
    {
        double y_onscreen = y_interval * _scale_y;
        [self drawYIntervalWithContext:context AtY:y_onscreen];
        NSString *intervalAsString = [NSString stringWithFormat:self->_yIntervalFormat, y_interval];
        CGPoint tip;
        tip.x = -cvChartGraphMarkerLength;
        tip.y = y_onscreen;
        [self drawGraphLabelWithContext:context WithText:intervalAsString
                                WithTip:tip InDirection:angle];
    }
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
