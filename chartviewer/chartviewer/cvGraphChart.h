//
//  cvGraphChartData.h
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChart.h"
#import "cvGraphChartDataPoint.h"
#import "cvGraphChartLabel.h"

struct graphChartDataLimits_struct {
    double mx, my, lx, ly;    // using notation m=most, l=least, thus lx is the least x value
};
typedef struct graphChartDataLimits_struct graphChartDataLimits;

enum cvAxis {
    cvAlongX,
    cvAlongY,
};

typedef enum cvAxis cvAxis;

@interface cvGraphChart : cvChart {
    NSString *_xIntervalFormat;
    NSString *_yIntervalFormat;
    const cvGraphChartDataPoint *_graphDataPoints;
    int _nDataPoints;
    BOOL readyToDraw;
    double _stepper_x;
    double _stepper_y;
    NSMutableArray *labels;
    
    /* Derived values from data points */
    graphChartDataLimits _limits;

    /* Derived values for when a graph is presented on the screen */
    double _scale_x;
    double _scale_y;
}

@property (copy, nonatomic) NSString *xIntervalFormat;
@property (copy, nonatomic) NSString *yIntervalFormat;

@property (readonly) graphChartDataLimits limits;
@property (readonly) double scale_x;
@property (readonly) double scale_y;


-(id)initWithTitle:(NSString *)string;
-(void)setGraphChartWithData:(const cvGraphChartDataPoint[]) data containingDataPoints:(size_t) size;
-(void)addLabelAt:(CGPoint)point InDirection:(double)direction WithText:(NSString*)text;
-(void)addIntervalsEvery:(double)periodicity AlongAxis:(cvAxis)axis WithFormat:(NSString*)format_string;

@end
