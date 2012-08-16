//
//  cvChartView.h
//  chartviewer
//
//  Created by Faisal Memon on 12/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cvChart.h"
#import "cvChartSelectionProtocol.h"

@interface cvChartView : UIView {
    /*
     We save the current orientation but strictly speaking, the view framework automatically adjusts our
     frame and bounds so it is not needed.  However, it could be useful so kept for the moment.
     */
    UIInterfaceOrientation currentOrientation;
    
    /*
     Details about the currently selected chart are delegated via a protocol.
     */
    id<cvChartSelectionProtocol> chartSelectionHandler;
}

/*
 Notes on behaviour:
 
 1.0 Orientation Change
 
 When the device is rotated, we need the drawRect method to be called so we can draw the graph in the new
 orientation.  This is why we have a handle to this object in cvViewController.  It is handled in two phases,
 I)  We are notified in advance of the rotation, with adjustToOrientation.
 II) We are told to redraw via a setNeedsDisplay.
 
 In phase I, we update our data model for the new orientation.  In phase II, we update the presentation of this model.
 
 */
- (void)drawAxes:(CGContextRef)context withBounds:(CGRect)bounds;
- (void)adjustToOrientation:(UIInterfaceOrientation)toOrientation;
- (void)setChartSelectionHandler:(id<cvChartSelectionProtocol>)target;
@end
