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
    [graph1 setGraphChartWithData:kSampleGraph1 containingDataPoints:sizeof(kSampleGraph1) / sizeof(cvGraphChartDataPoint)];
    [graph1 addIntervalsEvery:1 AlongAxis:cvAlongX WithFormat:@"%2.2f"];
    [graph1 addIntervalsEvery:1 AlongAxis:cvAlongY WithFormat:@"%2.2f"];
    CGPoint graph1xLabelAt = { -2, -1 };
    CGPoint graph1yLabelAt = { -0.5, 2 };
    [graph1 addLabelAt:graph1xLabelAt InDirection:0 WithText:@"X axis"];
    [graph1 addLabelAt:graph1yLabelAt InDirection:radians(90) WithText:@"Y axis"];

    cvGraphChart *graph2 = [[cvGraphChart alloc] initWithTitle:@"Bottom left" ];
    [graph2 setGraphChartWithData:kSampleGraph2 containingDataPoints:sizeof(kSampleGraph2) / sizeof(cvGraphChartDataPoint)];
    [graph2 addIntervalsEvery:1 AlongAxis:cvAlongX WithFormat:@"%2.2f"];
    [graph2 addIntervalsEvery:1 AlongAxis:cvAlongY WithFormat:@"%2.2f"];
    CGPoint graph2xLabelAt = { -1.75, -0.25 };
    CGPoint graph2yLabelAt = { -0.5, -2 };
    [graph2 addLabelAt:graph2xLabelAt InDirection:0 WithText:@"X axis"];
    [graph2 addLabelAt:graph2yLabelAt InDirection:radians(90) WithText:@"Y axis"];
    graphCharts = [NSArray arrayWithObjects:graph1, graph2, nil ];
    
    /*
     Pie Chart: Market share data Jul 2011 - Jul 2012

     SymbianOS      27
     iOS            23
     Android        23
     BlackBerry OS	8
     Samsung        6
     Other          13
     */
    cvPieChartDataPoint *dataSymbian = [[cvPieChartDataPoint alloc] initWithLabel:@"Symbian" WithWeight:27];
    cvPieChartDataPoint *dataiOS = [[cvPieChartDataPoint alloc] initWithLabel:@"iOS" WithWeight:23];
    cvPieChartDataPoint *dataAndroid = [[cvPieChartDataPoint alloc] initWithLabel:@"Android" WithWeight:23];
    cvPieChartDataPoint *dataBlackBerry = [[cvPieChartDataPoint alloc] initWithLabel:@"BlackBerry" WithWeight:8];
    cvPieChartDataPoint *dataSamsung = [[cvPieChartDataPoint alloc] initWithLabel:@"Samsung" WithWeight:6];
    cvPieChartDataPoint *dataOther = [[cvPieChartDataPoint alloc] initWithLabel:@"Other" WithWeight:13];

    NSString *formatUnits = @"%3.0f %%";

    cvPieChart *pieChartMobileOS = [[cvPieChart alloc] initWithData:[NSMutableArray arrayWithObjects:dataSymbian, dataiOS, dataAndroid, dataBlackBerry, dataSamsung, dataOther, nil] InFormatUnits:formatUnits WithTitle:@"Mobile OS Market Share "];

    pieCharts = [NSArray arrayWithObjects:pieChartMobileOS, nil];

}

-(int)getNumberOfChartsWithType:(int)chartType
{
    if (chartType == cvSegmentedControlGraphChart) {
        return [graphCharts count];
    } else if (chartType == cvSegmentedControlPieChart) {
        return [pieCharts count];
    }
    return 0;
}

-(NSArray *)getChartsWithType:(int)chartType
{
    if (chartType == cvSegmentedControlGraphChart) {
        return graphCharts;
    } else if (chartType == cvSegmentedControlPieChart) {
        return pieCharts;
    }
    return nil;
}

@end
