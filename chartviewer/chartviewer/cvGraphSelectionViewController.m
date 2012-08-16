//
//  cvGraphSelectionViewController.m
//  chartviewer
//
//  Created by Faisal Memon on 11/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvGraphSelectionViewController.h"
#import "cvConstants.h"

@interface cvGraphSelectionViewController ()

@end

@implementation cvGraphSelectionViewController
@synthesize selectedChartType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(cvChartPopOverWidth, cvChartPopOverHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedChartType = cvSegmentedControlGraphChart;
    self->model = [cvModel sharedInstance];
}

- (void)viewDidUnload
{
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
            self.selectedChartType = selectedSegment;
            break;
        }
        default:
        {
            self.selectedChartType = cvSegmentedControlGraphChart;
            break;
        }
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [model getNumberOfChartsWithType:selectedChartType];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] ;
    }
    cvChart *chart = [[model getChartsWithType:selectedChartType] objectAtIndex:indexPath.row];    
    cell.textLabel.text = [chart title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
}


@end
