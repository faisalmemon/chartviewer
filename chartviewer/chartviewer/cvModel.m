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
const cvGraphChartDataPoint kSampleGraph2[] = {-3,-3, -2,-2, 0,0};


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
    [graph1 setGraphChartWithData:kSampleGraph1 containingDataPoints:sizeof(kSampleGraph1) / sizeof(cvGraphChartDataPoint)];
    cvGraphChart *graph2 = [[cvGraphChart alloc] initWithString:@"Bottom left" ];
    [graph2 setGraphChartWithData:kSampleGraph2 containingDataPoints:sizeof(kSampleGraph2) / sizeof(cvGraphChartDataPoint)];
    graphCharts = [NSArray arrayWithObjects:graph1, graph2, nil ];
}


@end
