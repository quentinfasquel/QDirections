//
//  QRoute.m
//  QDirections
//
//  Created by Quentin Fasquel on 01/08/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "QRoute.h"

@implementation QRoute

@synthesize distance        = _distance;
@synthesize duration        = _duration;
@synthesize startAddress    = _startAddress;
@synthesize startLocation   = _startLocation;
@synthesize endAddress      = _endAddress;
@synthesize endLocation     = _endLocation;
@synthesize steps           = _steps;

@synthesize points          = _points;
@synthesize numberOfPoints  = _numberOfPoints;

- (void)dealloc {
    free(_points);
    [_distance release];
    [_duration release];
    [_startLocation release];
    [_endLocation release];
    [super dealloc];
}

@end
