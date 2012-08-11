//
//  cvViewController.m
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvViewController.h"

@interface cvViewController ()

@end

@implementation cvViewController
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
#if 0
    - (IBAction)openAllRhymes:(id)sender{
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
@end
