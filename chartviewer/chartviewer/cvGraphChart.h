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
    double mx, my, lx, ly;    // using notation m=most, l=least, thus lx is the least x value
};
typedef struct graphChartDataLimits_struct graphChartDataLimits;



@interface cvGraphChart : cvChart {
    NSString *_xLabel;
    NSString *_yLabel;
    const cvGraphChartDataPoint *_graphDataPoints;
    int _nDataPoints;
    graphChartDataLimits _limits;
    double _scale_x;
    double _scale_y;
    BOOL readyToDraw;
}

@property (copy, nonatomic) NSString *xLabel;
@property (copy, nonatomic) NSString *yLabel;
@property (readonly) graphChartDataLimits limits;
@property (readonly) double scale_x;
@property (readonly) double scale_y;


-(id)initWithString:(NSString *)string;
-(void)setGraphChartWithData:(const cvGraphChartDataPoint[]) data containingDataPoints:(size_t) size;

@end
