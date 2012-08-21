//
//  cvGraphSelectionViewController.h
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cvModel.h"
#import "cvChartSelectionProtocol.h"

@interface cvGraphSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    cvModel *model;
    id <cvChartSelectionProtocol>       chartSelectionHandler;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlHandle;
- (IBAction)selectedGraphType:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withChartSelectionHandler:(id<cvChartSelectionProtocol>)target;

@property (nonatomic) int selectedChartType;

@end
