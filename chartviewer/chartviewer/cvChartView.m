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

static inline double radians(double degrees) { return degrees * PI / 180; }

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

    [self drawAxes:context withBounds:bounds];
    
    CGContextRestoreGState(context);
}

- (void)drawAxes:(CGContextRef)context withBounds:(CGRect)bounds {
    NSLog(@"drawAxes: bounds is width %f height %f for origin %f %f", bounds.size.width, bounds.size.height, bounds.origin.x, bounds.origin.y);

    /* Simple positive quadrant axes filling given bounds */
    int nYaxisIntervals = 100;
    int nXaxisIntervals = 10;
    CGFloat widthYaxisInterval = 5;
    CGFloat heightXaxisInterval = 5;
    CGFloat paceAlongYaxis = (bounds.size.height - heightXaxisInterval) / nYaxisIntervals;
    CGFloat paceAlongXaxis = (bounds.size.width - widthYaxisInterval) / nXaxisIntervals;
    
    CGPoint* YaxisPoints;
    YaxisPoints = malloc(nYaxisIntervals * sizeof (CGPoint) * 2);
    
    CGPoint* XaxisPoints;
    XaxisPoints = malloc(nXaxisIntervals * sizeof (CGPoint) * 2);
    
    if (XaxisPoints == NULL || YaxisPoints == NULL) {
        goto cleanup_and_exit;
    }
    
    CGContextSaveGState(context);
	CGContextSetLineWidth(context, 3.0);
    
	CGContextSetGrayStrokeColor(context, 0.0, 1.0);
    
    for (int i = 0; i < nYaxisIntervals; i++) {
        YaxisPoints[i*2].x = 0;
        YaxisPoints[i*2].y = bounds.size.height - heightXaxisInterval - i * paceAlongYaxis;
        YaxisPoints[i*2+1].x = widthYaxisInterval;
        YaxisPoints[i*2+1].y = YaxisPoints[i*2].y;
    }
    
    for (int i = 0; i < nXaxisIntervals; i++) {
        XaxisPoints[i*2].x = widthYaxisInterval + i * paceAlongXaxis;
        XaxisPoints[i*2].y = bounds.size.height;
        XaxisPoints[i*2+1].x = XaxisPoints[i*2].x;
        XaxisPoints[i*2+1].y = bounds.size.height - heightXaxisInterval;
    }

    CGContextStrokeLineSegments(context, YaxisPoints, nYaxisIntervals * 2);
    CGContextStrokeLineSegments(context, XaxisPoints, nXaxisIntervals * 2);
    
	CGContextBeginPath(context);
    CGContextMoveToPoint(context, bounds.size.width, bounds.size.height - heightXaxisInterval);
    CGContextAddLineToPoint(context, widthYaxisInterval, bounds.size.height - heightXaxisInterval);
    CGContextAddLineToPoint(context, widthYaxisInterval, 0);
    CGContextStrokePath(context);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 50, 50);
    CGFloat targetWidth = bounds.size.width - 10;
    CGFloat targetHeight = bounds.size.height - 10;
    CGContextAddLineToPoint(context, targetWidth, targetHeight);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    
cleanup_and_exit:
    if (YaxisPoints)
        free(YaxisPoints);
    if (XaxisPoints)
        free(XaxisPoints);
    return;
}

- (void)drawRect:(CGRect)clip
{
    CGRect frame = [self frame];
    CGRect bounds = [self bounds];
    NSLog(@"drawRect:: frame %f %f %f %f ", frame.size.width, frame.size.height, frame.origin.x, frame.origin.y);
    NSLog(@"drawRect:: bounds %f %f %f %f ", bounds.size.width, bounds.size.height, bounds.origin.x, bounds.origin.y);

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


- (void)drawGraphYLabel:(CGContextRef)myContext :(CGRect)contextRect
{
    CGFloat w, h;
    w = contextRect.size.width;
    h = contextRect.size.height;
    
    CGAffineTransform myTextTransform;
    CGContextSelectFont (myContext,
                         "Helvetica-Bold",
                         h/10,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (myContext, 10);
    CGContextSetTextDrawingMode (myContext, kCGTextFillStroke);
    
    //CGContextSetRGBFillColor (myContext, 0, 1, 0, .5);
    //CGContextSetRGBStrokeColor (myContext, 0, 0, 1, 1);
    //myTextTransform =  CGAffineTransformMakeRotation  (radians(90));
    //CGContextSetTextMatrix (myContext, myTextTransform);
    CGContextShowTextAtPoint (myContext, 40, 0, "Confidence", 9);
    
}

- (void)setChartSelectionHandler:(id<cvChartSelectionProtocol>)target
{
    self->chartSelectionHandler = target;
}
@end
