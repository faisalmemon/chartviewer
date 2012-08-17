//
//  cvChartData.h
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cvChart : NSObject {
    NSString *_title;
}

@property (copy, nonatomic) NSString *title;

-(void) drawTitleInContext:(CGContextRef)context withBounds:(CGRect*)bounds updatingBounds:(BOOL)updateBounds updatingContext:(BOOL)updateContext;
-(void) drawChartBodyInContext:(CGContextRef)context withBounds:(CGRect)bounds;


@end
