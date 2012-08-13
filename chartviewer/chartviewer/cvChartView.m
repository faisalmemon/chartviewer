//
//  cvChartView.m
//  chartviewer
//
//  Created by Faisal Memon on 12/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChartView.h"

@implementation cvChartView

#define PI 3.14159265358979323846

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

    
    CGContextTranslateCTM(context, 30, 70);
    CGRect insetRect;
    insetRect = bounds;
    insetRect.size.height -= 70;
    insetRect.size.width  -= 30;
    
    insetRect.size.height -= 40;
    insetRect.size.width  -= 30;
    [self drawAxes:context withBounds:insetRect];
    
    CGContextRestoreGState(context);
}

- (void)drawAxes:(CGContextRef)context withBounds:(CGRect)bounds {
    
    /* Simple positive quadrant axes filling given bounds */
    int nYaxisIntervals = 10;
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

    CGContextRestoreGState(context);
    
cleanup_and_exit:
    if (YaxisPoints)
        free(YaxisPoints);
    if (XaxisPoints)
        free(XaxisPoints);
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


- (void)drawRect:(CGRect)clip
{
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextRotateCTM(context, angleToSupportOrientation);
	CGRect bounds = CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height);
	
	// create the graph
	[self drawGraphInContext:context withBounds:bounds];
	
    CGContextSetAllowsAntialiasing(context, true);
}


- (void)adjustToOrientation:(UIInterfaceOrientation)toOrientation
{
    switch (toOrientation) {
        default:
        case UIInterfaceOrientationPortrait:
            angleToSupportOrientation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            angleToSupportOrientation = radians(180);
        case UIInterfaceOrientationLandscapeLeft:
            angleToSupportOrientation = radians(90);
        case UIInterfaceOrientationLandscapeRight:
            angleToSupportOrientation = radians(-90);
            break;
    }
    return;
}


@end
