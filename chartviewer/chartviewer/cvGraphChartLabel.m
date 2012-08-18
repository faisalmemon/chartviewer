//
//  cvGraphChartLabel.m
//  chartviewer
//
//  Created by Faisal Memon on 18/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvGraphChartLabel.h"

@implementation cvGraphChartLabel

@synthesize text=_text, point=_point, direction=_direction;

-(id) initWithText:(NSString*)label_text At:(CGPoint)pos InDirection:(double)directionRadians {
    if (nil == label_text)
        return nil;
    
    self = [super init];
    if (self) {
        self->_text = label_text;
        self->_point = pos;
        self->_direction = directionRadians;
    }
    return self;
}

@end
