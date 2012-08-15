//
//  cvChartData.m
//  chartviewer
//
//  Created by Faisal Memon on 14/08/2012.
//  Copyright (c) 2012 Faisal Memon. All rights reserved.
//

#import "cvChartData.h"

@implementation cvChartData

@synthesize title=_title;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";
    }
    return self;
}

-(id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        self.title = string;
    }
    return self;
}

@end
