//
//  cvGraphChartLabel.h
//  chartviewer
//
//  Created by Faisal Memon on 18/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cvGraphChartLabel : NSObject {
    CGPoint _point;
    double _direction;
    NSString *_text;
}

@property (readonly)CGPoint point;
@property (readonly)double direction;
@property (readonly)NSString* text;

-(id) initWithText:(NSString*)label_text At:(CGPoint)pos InDirection:(double)directionRadians;
@end
