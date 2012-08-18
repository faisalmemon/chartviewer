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
    
    cvGraphChart *graph1 = [[cvGraphChart alloc] initWithString:@"My first graph" ];
    [graph1 setGraphChartWithData:kSampleGraph1 containingDataPoints:sizeof(kSampleGraph1) / sizeof(cvGraphChartDataPoint) WithIntervalStepsX:1 WithIntervalStepsY:1];
    [graph1 setXIntervalFormat:@"%2.2f"];
    [graph1 setYIntervalFormat:@"%2.2f"];
    CGPoint graph1xLabelAt = { -2, -1 };
    CGPoint graph1yLabelAt = { -0.5, 2 };
    [graph1 addLabelAt:graph1xLabelAt InDirection:0 WithText:@"X axis"];
    [graph1 addLabelAt:graph1yLabelAt InDirection:radians(90) WithText:@"Y axis"];

    cvGraphChart *graph2 = [[cvGraphChart alloc] initWithString:@"Bottom left" ];
    [graph2 setGraphChartWithData:kSampleGraph2 containingDataPoints:sizeof(kSampleGraph2) / sizeof(cvGraphChartDataPoint) WithIntervalStepsX:1 WithIntervalStepsY:1];
    [graph2 setXIntervalFormat:@"%2.2f"];
    [graph2 setYIntervalFormat:@"%2.2f"];
    CGPoint graph2xLabelAt = { -1.75, -0.25 };
    CGPoint graph2yLabelAt = { -0.5, -2 };
    [graph2 addLabelAt:graph2xLabelAt InDirection:0 WithText:@"X axis"];
    [graph2 addLabelAt:graph2yLabelAt InDirection:radians(90) WithText:@"Y axis"];
    graphCharts = [NSArray arrayWithObjects:graph1, graph2, nil ];
}

-(int)getNumberOfChartsWithType:(int)chartType
{
    if (chartType == cvSegmentedControlGraphChart) {
        return [graphCharts count];
    }
    return 0;
}

-(NSArray *)getChartsWithType:(int)chartType
{
    if (chartType == cvSegmentedControlGraphChart) {
        return graphCharts;
    }
    return nil;
}

@end
