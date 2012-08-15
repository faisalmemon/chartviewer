//
//  cvGraphChartData.h
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChart.h"
#import "cvGraphChartDataPoint.h"

struct graphChartDataLimits_struct {
    double mx, my, lx, ly;
};
typedef struct graphChartDataLimits_struct graphChartDataLimits;



@interface cvGraphChart : cvChart {
    NSString *_xLabel;
    NSString *_yLabel;
    const cvGraphChartDataPoint *_graphDataPoints;
    int _nDataPoints;
    // using notation m=most, l=least, thus lx is the least x value
    double mx,my,lx,ly;
}

@property (copy, nonatomic) NSString *xLabel;
@property (copy, nonatomic) NSString *yLabel;

-(id)initWithString:(NSString *)string;

-(graphChartDataLimits)getLimits;

@end
