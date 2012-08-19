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
}

@property (readonly)double weight;
@property (readonly)NSString* label;

-(id) initWithLabel:(NSString*)label WithWeight:(double)weight;

@end
