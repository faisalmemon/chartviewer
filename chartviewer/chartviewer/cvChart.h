//
//  cvChartData.h
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <Foundation/Foundation.h>

enum cvAxis {
    cvAlongX,
    cvAlongY,
};

@interface cvChart : NSObject {
    NSString *_title;
}

@property (copy, nonatomic) NSString *title;

-(id)initWithTitle:(NSString *)string;

-(void) drawTitleInContext:(CGContextRef)context
                withBounds:(CGRect*)bounds
            updatingBounds:(BOOL)updateBounds
           updatingContext:(BOOL)updateContext;

-(void) drawChartBodyInContext:(CGContextRef)context
                    withBounds:(CGRect)bounds;

/* Draw the specified label from the given position, returning the length of the label */
-(double) drawLabelWithContext:(CGContextRef)context
                      WithText:(NSString*)text
                  WithFontName:(const char *)font_name
                  WithFontSize:(CGFloat)font_size
          WithCharacterSpacing:(CGFloat)char_spacing
                     FromPoint:(CGPoint)from              /* where to start writing from on screen */
                   InDirection:(CGFloat)direction;

/* Draw the specified label to end at the given position, returning the length of the label */
-(double) drawLabelWithContext:(CGContextRef)context
                    WithText:(NSString*)text
                WithFontName:(const char *)font_name
                WithFontSize:(CGFloat)font_size
        WithCharacterSpacing:(CGFloat)char_spacing
                    EndPoint:(CGPoint)end_point         /* where to finish writing to on screen */
                 InDirection:(CGFloat)direction;

+(double) labelLengthInContext:(CGContextRef)context
                      WithText:(NSString*)text
                  WithFontName:(const char *)font_name
                  WithFontSize:(CGFloat)font_size
          WithCharacterSpacing:(CGFloat)char_spacing;

@end
