//
//  QRouteStep.m
//  QDirections
//
//  Created by Quentin Fasquel on 29/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "QRouteStep.h"
#import "QRouteStepInternal.h"

@implementation QRouteStep

@synthesize startLocation = _startLocation;
@synthesize endLocation = _endLocation;

- (void)dealloc {
    [_dictionary release];
    [_startLocation release];
    [_endLocation release];
    [super dealloc];
}

- (NSString *)distance {
    return [_dictionary valueForKeyPath:@"distance.text"];
}

- (NSString *)duration {
    return [_dictionary valueForKeyPath:@"duration.text"];
}

- (NSString *)htmlInstructions {
    return [_dictionary valueForKeyPath:@"html_instructions"];
}

- (NSString *)travelMode {
    return [_dictionary valueForKeyPath:@"travel_mode"];
}

@end

#pragma mark -

@implementation QRouteStep (Internal)

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init]))
    {
        _startLocation = [[CLLocation alloc] initWithLatitude:[[dictionary valueForKeyPath:@"start_location.lat"] doubleValue]
                                                    longitude:[[dictionary valueForKeyPath:@"start_location.lng"] doubleValue]];
        _endLocation   = [[CLLocation alloc] initWithLatitude:[[dictionary valueForKeyPath:@"start_location.lat"] doubleValue]
                                                    longitude:[[dictionary valueForKeyPath:@"start_location.lng"] doubleValue]];
        _dictionary = [dictionary retain];
    }
    
    return self;
}

@end


