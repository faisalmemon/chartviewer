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
    NSLog(@"cvChart cannot draw the chart body because it is established in subclasses of cvChart");
    return;
}


@end
