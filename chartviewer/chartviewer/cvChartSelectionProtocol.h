//
//  cvChartSelectionProtocol.h
//  chartviewer
//
//  Created by Faisal Memon on 16/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cvChart.h"

@protocol cvChartSelectionProtocol <NSObject>

-(void)cvChartWasNotSelected;
-(void)cvChartWasSelected:(cvChart *)item;
-(void)cvChartTypeWasSelected:(int)chartType;
-(BOOL)cvIsAnyChartSelected;
-(cvChart*)cvGetSelectedChart;
-(int)cvSelectedChartType;

@end
