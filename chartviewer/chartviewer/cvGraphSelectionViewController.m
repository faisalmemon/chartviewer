//
//  cvGraphSelectionViewController.m
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvGraphSelectionViewController.h"
#import "cvConstants.h"

@implementation cvGraphSelectionViewController
@synthesize tableView;
@synthesize segmentedControlHandle;
@synthesize selectedChartType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withChartSelectionHandler:(id<cvChartSelectionProtocol>)target
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(cvChartPopOverWidth, cvChartPopOverHeight);
        self->chartSelectionHandler = target;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [segmentedControlHandle setSelectedSegmentIndex:[self->chartSelectionHandler cvSelectedChartType]];
    self->model = [cvModel sharedInstance];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSegmentedControlHandle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)selectedGraphType:(id)sender {
    int selectedSegment = ((UISegmentedControl *)sender).selectedSegmentIndex;
    switch (selectedSegment)
    {
        case cvSegmentedControlGraphChart:
        case cvSegmentedControlPieChart:
        case cvSegmentedControlBarChart:
        {
            [chartSelectionHandler cvChartTypeWasSelected:selectedSegment];
            [tableView reloadData];
            break;
        }
        default:
        {
            [chartSelectionHandler cvChartTypeWasSelected:cvSegmentedControlGraphChart];
            [tableView reloadData];
            break;
        }
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [model getNumberOfChartsWithType:[chartSelectionHandler cvSelectedChartType]];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)table_view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"cvChartViewerChartList";
    UITableViewCell *cell = [table_view dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
    }
    int row = indexPath.row;
    int chartType = [chartSelectionHandler cvSelectedChartType];
    cvChart *chart = [[model getChartsWithType:chartType] objectAtIndex:row];
    //NSLog(@"Table View Cell title %@ came from row %d type %d cvChart %@", [chart title], row, chartType, chart);
    cell.textLabel.text = [chart title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cvChart *chart = [[model getChartsWithType:[chartSelectionHandler cvSelectedChartType]] objectAtIndex:indexPath.row];

    [chartSelectionHandler cvChartWasSelected:chart];
}

@end
