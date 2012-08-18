//
//  cvViewController.h
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cvChartView.h"
#import "cvChartSelectionProtocol.h"

@interface cvViewController : UIViewController <UIPopoverControllerDelegate, cvChartSelectionProtocol, UIScrollViewDelegate>
{
    /* For the cvChartSelectionProtocol */
    int selectedChartType;
    BOOL chartSelected;
    cvChart* chart;
}

@property (weak, nonatomic) IBOutlet cvChartView *chartViewHandle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *chartButton;
@property (strong, nonatomic) UIPopoverController *popoverController;
@property (nonatomic) UIInterfaceOrientation orientation;

- (IBAction)chartButtonAction:(id)sender;

@end
