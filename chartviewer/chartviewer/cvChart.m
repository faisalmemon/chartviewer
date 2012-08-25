//
//  cvChartData.m
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChart.h"
#import "cvConstants.h"

@implementation cvChart

@synthesize title=_title;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";
    }
    return self;
}

-(id)initWithTitle:(NSString *)string {
    self = [super init];
    if (self) {
        self.title = string;
    }
    return self;
}

+(double) labelLengthInContext:(CGContextRef)context
                      WithText:(NSString*)text
                  WithFontName:(const char *)font_name
                  WithFontSize:(CGFloat)font_size
          WithCharacterSpacing:(CGFloat)char_spacing
{
    CGContextSaveGState(context);
    CGContextSelectFont (context,
                         font_name,
                         font_size,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (context, char_spacing);
    CGContextMoveToPoint(context, 0, 0);
    
    /* Dummy write to assess the length of text */
    CGPoint startingPosition = CGContextGetTextPosition(context);
    CGContextSetTextDrawingMode(context, kCGTextInvisible);
    CGContextShowText (context, text.UTF8String, strlen(text.UTF8String));
    CGPoint actualEndPoint = CGContextGetTextPosition(context);
    double widthOfText = actualEndPoint.x - startingPosition.x;
    CGContextRestoreGState(context);
    return widthOfText;
}

-(double) drawLabelWithContext:(CGContextRef)context
                      WithText:(NSString*)text
                  WithFontName:(const char *)font_name
                  WithFontSize:(CGFloat)font_size
          WithCharacterSpacing:(CGFloat) char_spacing
                     FromPoint:(CGPoint)from                  /* where to start writing from on screen */
                   InDirection:(CGFloat)direction
{
    CGContextSaveGState(context);
    CGContextSelectFont (context,
                         font_name,
                         font_size,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (context, char_spacing);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextTranslateCTM(context, from.x, from.y);
    CGContextMoveToPoint(context, 0, 0);
    
    /* Dummy write to assess the length of text */
    CGPoint startingPosition = CGContextGetTextPosition(context);
    CGContextSetTextDrawingMode(context, kCGTextInvisible);
    CGContextShowText (context, text.UTF8String, strlen(text.UTF8String));
    CGPoint actualEndPoint = CGContextGetTextPosition(context);
    double widthOfText = actualEndPoint.x - startingPosition.x;
    CGContextMoveToPoint(context, 0, 0);
    CGContextSetTextDrawingMode (context, kCGTextFill);

    CGContextRotateCTM(context, direction);
    CGContextScaleCTM(context, 1, -1); //for text system, to avoid mirror-effect writing
    CGContextSetTextDrawingMode (context, kCGTextFill);
    CGContextShowTextAtPoint (context, 0, 0, text.UTF8String, strlen(text.UTF8String));
    CGContextRestoreGState(context);
    return widthOfText;
}

-(double) drawLabelWithContext:(CGContextRef)context
                      WithText:(NSString*)text
                  WithFontName:(const char *)font_name
                  WithFontSize:(CGFloat)font_size
          WithCharacterSpacing:(CGFloat) char_spacing
                      EndPoint:(CGPoint)end_point             /* where to finish writing to on screen */
                   InDirection:(CGFloat)direction
{
    CGContextSaveGState(context);
    CGContextSelectFont (context,
                         font_name,
                         font_size,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (context, char_spacing);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    
    /*
     The end_point is where we want text to end (ie. not start)
     */
    CGContextTranslateCTM(context, end_point.x, end_point.y);
    CGContextMoveToPoint(context, 0, 0);
    
    /*
     We are now at the place where we want the label to end.
     We do an invisible write of the label, find the delta in position
     and then do visible writing from the -delta position to end up at
     the correct end point.
     */
    CGPoint desiredEndPoint = CGContextGetTextPosition(context);
    CGContextSetTextDrawingMode(context, kCGTextInvisible);
    CGContextShowText (context, text.UTF8String, strlen(text.UTF8String));
    CGPoint actualEndPoint = CGContextGetTextPosition(context);
    double widthOfText = actualEndPoint.x - desiredEndPoint.x;
    CGContextMoveToPoint(context, 0, 0);
    
    CGContextRotateCTM(context, direction);
    CGContextTranslateCTM(context, -widthOfText, 0);
    CGContextScaleCTM(context, 1, -1); // for text system, to avoid mirror-effect writing
    
    CGContextSetTextDrawingMode (context, kCGTextFill);
    CGContextShowTextAtPoint (context, 0, 0, text.UTF8String, strlen(text.UTF8String));
    
    CGContextRestoreGState(context);
    
    return widthOfText;
}

-(void) drawTitleInContext:(CGContextRef)context withBounds:(CGRect*)bounds updatingBounds:(BOOL)updateBounds updatingContext:(BOOL)updateContext
{
    if (!updateContext) {
        CGContextSaveGState(context);
    }
    
    CGRect titleBoundingRect;
    titleBoundingRect.origin.x = 0;
    titleBoundingRect.origin.y = 0;
    titleBoundingRect.size.width = bounds->size.width;
    titleBoundingRect.size.height = cvChartInsetToAllowTitle;
    
    [_title drawInRect:titleBoundingRect withFont: [UIFont fontWithName:@"Helvetica-Bold" size:cvChartTitleFontSize ] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    
    if (updateBounds) {
        bounds->size.height -= cvChartInsetToAllowTitle;
    }
    
    if (updateContext) {
        CGContextTranslateCTM(context, 0, cvChartInsetToAllowTitle);
    }
    
    if (!updateContext) {
        CGContextRestoreGState(context);
    }
}
-(void) drawChartBodyInContext:(CGContextRef)context withBounds:(CGRect)bounds
{
    NSLog(@"cvChart does not draw the chart body because it is established in subclasses of cvChart");
    return;
}


@end
