//
//  cvViewController.h
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cvViewController : UIViewController <UIPopoverControllerDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *chartButton;
@property (strong, nonatomic) UIPopoverController *popoverController;

- (IBAction)chartButtonAction:(id)sender;

@end
