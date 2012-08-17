//
//  cvViewController.m
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvViewController.h"
#import "cvGraphSelectionViewController.h"

@interface cvViewController ()

@end

@implementation cvViewController
@synthesize popoverController;
@synthesize chartViewHandle;
@synthesize chartButton;
@synthesize orientation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (nil != chartViewHandle) {
        [chartViewHandle adjustToOrientation:UIInterfaceOrientationPortrait];
        [chartViewHandle setChartSelectionHandler:self];
    }


}

- (void)viewDidUnload
{
    [self setChartButton:nil];
    [self setChartViewHandle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
	   orientation = toInterfaceOrientation;
    if (nil != chartViewHandle) {
        [chartViewHandle adjustToOrientation:orientation];
    }

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (nil == chartViewHandle) {
        NSLog (@"The view to custom draw the graph did not load so we cannot redraw it");
    } else {
        [chartViewHandle setNeedsDisplay];
    }

    return;
}

- (IBAction)chartButtonAction:(id)sender {

    if (nil != self.popoverController) {
        /*
         We have pressed the chart button whilst the chart popover is already on the screen.
         Creating another popover is the wrong action.  We should dismiss the current popover instead.
         */
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
        return;
    }
    cvGraphSelectionViewController* content = [[cvGraphSelectionViewController alloc] initWithNibName:@"cvGraphSelectionViewController" bundle:nil withChartSelectionHandler:self];
    self.popoverController = [[UIPopoverController alloc]
                                     initWithContentViewController:content];

    self.popoverController.delegate = self;

    [self.popoverController presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];    
}

/* 
 Implementing protocol UIPopoverControllerDelegate
 */
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}


/* 
 Implementing protocol UIPopoverControllerDelegate
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popoverController = nil;
}

/*
 Implementing protocol cvChartSelectionProtocol
 */
-(void)cvChartWasNotSelected
{
    self->chartSelected = NO;
}
/*
 Implementing protocol cvChartSelectionProtocol
 */
-(void)cvChartWasSelected:(cvChart *)item
{
    self->chartSelected = YES;
    self->chart = item;
    [chartViewHandle setNeedsDisplay];
}
/*
 Implementing protocol cvChartSelectionProtocol
 */
-(void)cvChartTypeWasSelected:(int)chartType
{
    self->selectedChartType = chartType;
}
/*
 Implementing protocol cvChartSelectionProtocol
 */
-(int)cvSelectedChartType
{
    return self->selectedChartType;
}

-(BOOL)cvIsAnyChartSelected
{
    return self->chartSelected;
}

-(cvChart*)cvGetSelectedChart
{
    if (self->chartSelected) {
        return self->chart;
    } else {
        return nil;
    }
}

@end
