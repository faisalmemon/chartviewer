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
#define ARC4RANDOM_MAX      0x100000000


enum cvConstants_t {
    /* Derived from cvGraphSelectionViewController.xib */
    cvChartPopOverWidth             = 360,
    cvChartPopOverHeight            = 544,
    
    /* For cvChartView */
    cvSegmentedControlGraphChart    = 0,
    cvSegmentedControlPieChart      = 1,
    cvSegmentedControlBarChart      = 2,
    cvChartTitleFontSize            = 30,
    cvChartInsetToAllowTitle        = cvChartTitleFontSize + 10,
    cvChartInsetToAllowGraphLabels  = 30,
    cvChartGraphDataPointSize       = 4,  // this is up and left 4 points, then filling a 16x16 square
    cvChartGraphIntervals           = 10, // number of interval marking points on either axis
    cvChartGraphMarkerLength        = cvChartInsetToAllowGraphLabels / 5,
    
    /* For pinch and zoom */
    cvMinMagnification = 1, // cannot zoom out more than the normal graph because it just gives white space
    cvMaxMagnification = 6,
    cvScrollAreaX = 1280, // don't make it too wide otherwise scrolling is a long activity
    cvScrollAreaY = 960,  // ...or too tall
    
    /* For pie charts */
    cvPieChartDataTableXOffset  = 210,
    cvPieChartDataTableYOffset  = 80,
    cvPieChartDataTableXGutter  = 40,
    cvPieChartDataTableYGutter  = 40,
    cvChartDataTableYPace       = 30,
    cvChartKeyBoxSize           = 15,
};

static inline double radians(double degrees) { return degrees * PI / 180; }
static inline int   radiansWithinRange(double radians) { return (radians > 0) && (radians < 2 * PI); }
static inline double clampRadiansWithinRange(double radians) {
    if (radians < 0)
        return 0;
    else if (radians > 2*PI)
        return 2*PI;
    else
        return radians;
};
static inline int radiansInLeftSemicircle(double radians) {
    return radians > PI * 0.5 && radians < PI * 1.5;
}

extern const char * cvChartLabelFont;
extern const double cvChartLabelFontSize;
extern const double cvChartLabelFontSpacing;
extern const char * cvChartIntervalLabelFont;
extern const double cvChartIntervalLabelFontSize;
extern const double cvChartIntervalLabelFontSpacing;


#endif
