//
//  cvBarChartDataPoint.h
//  chartviewer
//
//  Created by Faisal Memon on 21/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cvBarChartDataPoint : NSObject {
    /* supplied data */
    double _yValue;
    NSString *_xLabel;
}

@property (readonly) NSString *xLabel;
@property (readonly) double yValue;

-(id) initWithLabel:(NSString*)label WithValue:(double)value;

@end
