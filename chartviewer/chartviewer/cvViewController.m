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
@synthesize chartButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setChartButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
    cvGraphSelectionViewController* content = [[cvGraphSelectionViewController alloc] initWithNibName:@"cvGraphSelectionViewController" bundle:nil];
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
@end
