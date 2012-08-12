//
//  cvGraphSelectionViewController.h
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cvGraphSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
- (IBAction)selectedGraphType:(id)sender;
@property (nonatomic) int selectedChartType;

@end
