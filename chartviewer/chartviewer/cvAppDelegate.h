//
//  cvAppDelegate.h
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class cvViewController;

@interface cvAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) cvViewController *viewController;

@end
