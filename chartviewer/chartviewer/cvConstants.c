//
//  cvConstants.c
//  chartviewer
//
//  Created by Faisal Memon on 19/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#include <stdio.h>
#include "cvConstants.h"

const char *cvChartLabelFont            = "Helvetica";
const char *cvChartIntervalLabelFont    = "Helvetica";

const double cvChartLabelFontSize               = 1;
const double cvChartLabelFontSpacing            = 0.2;
const double cvChartIntervalLabelFontSize       = 0.5;
const double cvChartIntervalLabelFontSpacing    = 0.1;

/*
 Try a generate a contrasting set of colors when shown in sequence.
 We do this by choosing in turn the maximum in the axis r,g,b.  When
 exhausted, we try adding a mid value in turn to r,g,b, and so on
 with smaller deltas.  We use unsigned char overflow to ensure we
 stay within RGBA8888 limits.  Since black is often used for lines,
 we skip over black as our first color palette index.
 */
struct cv_rgba_t cvGetContrastingColor(int paletteIndex) {
    struct cv_rgba_t result = {0,0,0,0xff};

    unsigned char index = (unsigned char) paletteIndex;
    
    index++;
    
    if (index&0x1) {
        result.r += 0xff;
    }
    if (index&0x2) {
        result.g += 0xff;
    }
    if (index&0x4) {
        result.b += 0xff;
    }
    if (index&0x8) {
        result.r += 0x80;
    }
    if (index&0x10) {
        result.g += 0x80;
    }
    if (index&0x20) {
        result.b += 0x80;
    }
    if (index&0x40) {
        result.r += 0x40;
    }
    if (index&0x80) {
        result.g += 0x40;
    }
    
    return result;
}
