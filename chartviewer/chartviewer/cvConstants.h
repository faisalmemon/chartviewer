//
//  cvConstants.h
//  chartviewer
//
//  Created by Faisal Memon on 12/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#ifndef chartviewer_cvConstants_h
#define chartviewer_cvConstants_h


#define PI 3.14159265358979323846

enum cvConstants_t {
    /* Derived from cvGraphSelectionViewController.xib */
    
    cvChartPopOverWidth             = 360,
    cvChartPopOverHeight            = 544,
    cvSegmentedControlGraphChart    = 0,
    cvSegmentedControlPieChart      = 1,
    cvSegmentedControlBarChart      = 2,
    cvChartTitleFontSize            = 30,
    cvChartInsetToAllowTitle        = cvChartTitleFontSize + 10,
    cvChartInsetToAllowGraphLabels  = 30,
    cvChartGraphDataPointSize       = 4,  // this is up and left 4 points, then filling a 16x16 square
    cvChartGraphIntervals           = 10, // number of interval marking points on either axis
    cvChartGraphMarkerLength        = cvChartInsetToAllowGraphLabels / 5,
};

#endif
