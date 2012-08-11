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

    
    cvGraphSelectionViewController* content = [[cvGraphSelectionViewController alloc] initWithNibName:@"cvGraphSelectionViewController" bundle:nil];
    self.popoverController = [[UIPopoverController alloc]
                                     initWithContentViewController:content];

    self.popoverController.delegate = self;

    [self.popoverController presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

#if 0
    //
        UIButton *button = (UIButton*)sender;
        
        PopupTableView *tableViewController = [[PopupTableView alloc] initWithStyle:UITableViewStylePlain];
        
        
        popover = [[UIPopoverController alloc] initWithContentViewController:tableViewController];
        [popover presentPopoverFromRect:CGRectMake(button.frame.size.width / 2, button.frame.size.height / 1, 1, 1) inView:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        [tableViewController release];
    }
    
    Now you have created a tableview for popover in that tableviewcontroller write:
        
        self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(108,400);
#endif
    
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
