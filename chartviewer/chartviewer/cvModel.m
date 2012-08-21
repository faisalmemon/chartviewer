//
//  cvModel.m
//  chartviewer
//
//  Created by Faisal Memon on 15/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvModel.h"

@implementation cvModel

const cvGraphChartDataPoint kSampleGraph1[] = {-3,-3, -2,2, 0,3, 1,6};
const cvGraphChartDataPoint kSampleGraph2[] = {-3,-3, -2,-1, 0,0};


+ (id)sharedInstance
{
	static id master = nil;
	
	@synchronized(self)
	{
		if (master == nil) {
            master = [self new];
            [master loadData];
        }
	}
    
    return master;
}

-(void)loadData
{
    // Add hardcoded data since we have no UI or web service for adding new graphs
    
    cvGraphChart *graph1 = [[cvGraphChart alloc] initWithTitle:@"My first graph" ];
    [graph1 addDataSet:kSampleGraph1 withSize:sizeof(kSampleGraph1) / sizeof(cvGraphChartDataPoint)];
    [graph1 addIntervalsEvery:1 AlongAxis:cvAlongX WithFormat:@"%2.2f"];
    [graph1 addIntervalsEvery:1 AlongAxis:cvAlongY WithFormat:@"%2.2f"];
    CGPoint graph1xLabelAt = { -2, -1 };
    CGPoint graph1yLabelAt = { -0.5, 2 };
    [graph1 addLabelAt:graph1xLabelAt InDirection:0 WithText:@"X axis"];
    [graph1 addLabelAt:graph1yLabelAt InDirection:radians(90) WithText:@"Y axis"];

    cvGraphChart *graph2 = [[cvGraphChart alloc] initWithTitle:@"Bottom left" ];
    [graph2 addDataSet:kSampleGraph2 withSize:sizeof(kSampleGraph2) / sizeof(cvGraphChartDataPoint)];
    [graph2 addIntervalsEvery:1 AlongAxis:cvAlongX WithFormat:@"%2.2f"];
    [graph2 addIntervalsEvery:1 AlongAxis:cvAlongY WithFormat:@"%2.2f"];
    CGPoint graph2xLabelAt = { -1.75, -0.25 };
    CGPoint graph2yLabelAt = { -0.5, -2 };
    [graph2 addLabelAt:graph2xLabelAt InDirection:0 WithText:@"X axis"];
    [graph2 addLabelAt:graph2yLabelAt InDirection:radians(90) WithText:@"Y axis"];
    _graphCharts = [NSArray arrayWithObjects:graph1, graph2, nil ];
    
    /*
     Pie Chart: Smartphone sales 2012Q2

     SymbianOS      9800
     iOS            30000
     Android        100000
     BlackBerry OS	9000
     Bada           5000
     Windows        4000
     */
    cvPieChartDataPoint *dataSymbian = [[cvPieChartDataPoint alloc] initWithLabel:@"Symbian" WithWeight:9800];
    cvPieChartDataPoint *dataiOS = [[cvPieChartDataPoint alloc] initWithLabel:@"iOS" WithWeight:30000];
    cvPieChartDataPoint *dataAndroid = [[cvPieChartDataPoint alloc] initWithLabel:@"Android" WithWeight:100000];
    cvPieChartDataPoint *dataBlackBerry = [[cvPieChartDataPoint alloc] initWithLabel:@"BlackBerry" WithWeight:9000];
    cvPieChartDataPoint *dataSamsung = [[cvPieChartDataPoint alloc] initWithLabel:@"Bada" WithWeight:5000];
    cvPieChartDataPoint *dataOther = [[cvPieChartDataPoint alloc] initWithLabel:@"Windows" WithWeight:4000];

    NSString *formatUnits = @"%6.0f units";

    cvPieChart *pieChartMobileOS = [[cvPieChart alloc] initWithData:[NSMutableArray arrayWithObjects:dataSymbian, dataiOS, dataAndroid, dataBlackBerry, dataSamsung, dataOther, nil] InFormatUnits:formatUnits WithTitle:@"Smartphone sales 2012 Q2"];

    _pieCharts = [NSArray arrayWithObjects:pieChartMobileOS, nil];
    
    /*
     Average Inflation in USA per decade
     1913-1919	9.8
     1920-1929	-0.09
     1930-1939	-2.08
     1940-1949	5.52
     1950-1959	2.04
     1960-1969	2.32
     1970-1979	7.06
     1980-1989	5.51
     1990-1999	3.00
     2000-2009	2.56
     */
    cvBarChartDataPoint *data1913 = [[cvBarChartDataPoint alloc] initWithLabel:@"1913-1919" WithValue:9.8];
    cvBarChartDataPoint *data1920 = [[cvBarChartDataPoint alloc] initWithLabel:@"1920-1929" WithValue:-0.09];
    cvBarChartDataPoint *data1930 = [[cvBarChartDataPoint alloc] initWithLabel:@"1930-1939" WithValue:-2.08];
    cvBarChartDataPoint *data1940 = [[cvBarChartDataPoint alloc] initWithLabel:@"1940-1949" WithValue:5.52];
    cvBarChartDataPoint *data1950 = [[cvBarChartDataPoint alloc] initWithLabel:@"1950-1959" WithValue:2.04];
    cvBarChartDataPoint *data1960 = [[cvBarChartDataPoint alloc] initWithLabel:@"1960-1969" WithValue:2.32];
    cvBarChartDataPoint *data1970 = [[cvBarChartDataPoint alloc] initWithLabel:@"1970-1979" WithValue:7.06];
    cvBarChartDataPoint *data1980 = [[cvBarChartDataPoint alloc] initWithLabel:@"1980-1989" WithValue:5.51];
    cvBarChartDataPoint *data1990 = [[cvBarChartDataPoint alloc] initWithLabel:@"1990-1999" WithValue:3.0];
    cvBarChartDataPoint *data2000 = [[cvBarChartDataPoint alloc] initWithLabel:@"2000-2009" WithValue:2.56];

    NSMutableArray* inflationData = [NSMutableArray arrayWithObjects:
                                     data1913, data1920, data1930, data1940, data1950, data1960,
                                     data1970, data1980, data1990, data2000, nil];
    cvBarChart *barChartInflation = [[cvBarChart alloc] initWithTitle:@"Average USA Inflation" WithDataSet:inflationData];
    
    _barCharts = [NSArray arrayWithObjects:barChartInflation, nil];
    
}

-(int)getNumberOfChartsWithType:(int)chartType
{
    if (chartType == cvSegmentedControlGraphChart) {
        return [_graphCharts count];
    } else if (chartType == cvSegmentedControlPieChart) {
        return [_pieCharts count];
    } else if (chartType == cvSegmentedControlBarChart) {
        return [_barCharts count];
    }
    return 0;
}

-(NSArray *)getChartsWithType:(int)chartType
{
    if (chartType == cvSegmentedControlGraphChart) {
        return _graphCharts;
    } else if (chartType == cvSegmentedControlPieChart) {
        return _pieCharts;
    } else if (chartType == cvSegmentedControlBarChart) {
        return _barCharts;
    }
    return nil;
}

@end
