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
        // Initialization code
    }
    return self;
}

- (void)drawGraphInContext:(CGContextRef)context withBounds:(CGRect)bounds {
    CGFloat value, temp;
    
    // Save any previous graphics state settings before setting the color and line width for the current draw.
    CGContextSaveGState(context);
	CGContextSetLineWidth(context, 1.0);
    
	// Draw the intermediate lines
	CGContextSetGrayStrokeColor(context, 0.6, 1.0);
	CGContextBeginPath(context);
	for (value = -5 + 1.0; value <= 5 - 1.0; value += 1.0) {
        
		if (value == 0.0) {
			continue;
		}
		temp = 0.5 + roundf(bounds.origin.y + bounds.size.height / 2 + value / (2 * 5) * bounds.size.height);
		CGContextMoveToPoint(context, bounds.origin.x, temp);
		CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, temp);
	}
	CGContextStrokePath(context);
	
	// Draw the center line
	CGContextSetGrayStrokeColor(context, 0.25, 1.0);
	CGContextBeginPath(context);
	temp = 0.5 + roundf(bounds.origin.y + bounds.size.height / 2);
	CGContextMoveToPoint(context, bounds.origin.x, temp);
	CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, temp);
	CGContextStrokePath(context);
    
    // Restore previous graphics state.
    CGContextRestoreGState(context);
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


- (void)drawRect:(CGRect)clip {
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect bounds = CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height);
	
	// create the graph
	[self drawGraphInContext:context withBounds:bounds];
	
    CGContextSetAllowsAntialiasing(context, true);
}

#if 0
- (void)drawRect:(CGRect)rect
{
    
    // Create an oval shape to draw.
    UIBezierPath* aPath = [UIBezierPath bezierPathWithOvalInRect:
                           CGRectMake(0, 0, 200, 100)];
    
    // Set the render colors
    [[UIColor blackColor] setStroke];
    [[UIColor redColor] setFill];
    
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    [self drawGraphYLabel:aRef :CGRectMake(0,0, 30, 300)];
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    CGContextTranslateCTM(aRef, 50, 50);
    
    // Adjust the drawing options as needed.
    aPath.lineWidth = 5;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [aPath fill];
    [aPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
    
}
#endif


@end
