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
    NSString *_xIntervalFormat;
    NSString *_yIntervalFormat;
    const cvGraphChartDataPoint *_graphDataPoints;
    int _nDataPoints;
    graphChartDataLimits _limits;
    BOOL readyToDraw;
    double _stepper_x;
    double _stepper_y;
    double _offsetXLabel;
    double _offsetYLabel;
    
    /* These are derived values for when a graph is presented on the screen */
    double _scale_x;
    double _scale_y;
}

@property (copy, nonatomic) NSString *xLabel;
@property (copy, nonatomic) NSString *yLabel;
@property (copy, nonatomic) NSString *xIntervalFormat;
@property (copy, nonatomic) NSString *yIntervalFormat;

@property (readonly) graphChartDataLimits limits;
@property (readonly) double scale_x;
@property (readonly) double scale_y;


-(id)initWithString:(NSString *)string;
-(void)setGraphChartWithData:(const cvGraphChartDataPoint[]) data containingDataPoints:(size_t) size
          WithIntervalStepsX:(double)steps_x WithIntervalStepsY:(double)steps_y WithXLabel:(NSString*)label_x WithXLabelAlignedTo:(double)offset_x_label WithYLabel:(NSString*)label_y WithYLabelAlignedTo:(double)offset_y_label;

@end
