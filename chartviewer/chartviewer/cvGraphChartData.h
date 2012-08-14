//
//  cvGraphChartData.h
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChartData.h"

@interface cvGraphChartData : cvChartData {
    NSString *_xLabel;
    NSString *_yLabel;
    NSArray *_graphDataPoints;
}

@property (strong, nonatomic) NSString *xLabel;
@property (strong, nonatomic) NSString *yLabel;

@end
