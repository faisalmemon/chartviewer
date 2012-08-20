//
//  cvPieChartDataPoint.h
//  chartviewer
//
//  Created by Faisal Memon on 19/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cvPieChartDataPoint : NSObject {
    NSString *_label;
    // all data points carry a weight, and percentages are derived from this
    double _weight;
    
    // computed data calculated once all other data points are specified
    CGFloat _red, _green, _blue, _alpha; // color of segment
    double _startingAngleOfSlice;        // radians rotation from x axis for the starting edge of slice
    double _endingAngleOfSlice;          // radians rotation from x axis for the ending edge of slice
    double _labelAngle;                  // radians rotation from x axis for the position of the label outside the slice
}

@property (readonly)double weight;
@property (readonly)NSString* label;
@property (readonly)CGFloat red;
@property (readonly)CGFloat green;
@property (readonly)CGFloat blue;
@property (readonly)CGFloat alpha;
@property (readonly)double labelAngle;
@property (readonly)double startingAngle;
@property (readonly)double endingAngle;



-(id) initWithLabel:(NSString*)label WithWeight:(double)weight;
-(void) setSliceAnglesStarting:(double)start_angle Ending:(double)end_angle;
-(void) setLabelAngle:(double)label_angle;
-(void) setColor:(UIColor*)color;

@end
