//
//  DirectionsResponse.m
//  QDirections
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "DirectionsResponse.h"
#import "QRoute.h"
#import "QRouteStepInternal.h"
#import "JSONKit.h"

NSString * const kDirectionsStatusCodeOk                    = @"OK";
NSString * const kDirectionsStatusCodeNotFound              = @"NOT_FOUND";
NSString * const kDirectionsStatusCodeZeroResults           = @"ZERO_RESULTS";
NSString * const kDirectionsStatusCodeMaxWaypointsExceeded  = @"MAX_WAYPOINTS_EXCEEDED";
NSString * const kDirectionsStatusCodeInvalidRequest        = @"INVALID_REQUEST";
NSString * const kDirectionsStatusCodeOverQueryLimit        = @"OVER_QUERY_LIMIT";
NSString * const kDirectionsStatusCodeRequestDenied         = @"REQUEST_DENIED";
NSString * const kDirectionsStatusCodeUnknownError          = @"UNKNOWN_ERROR";

@interface DirectionsResponse ()
- (NSMutableArray *)decodePolyline:(NSString *)encodedStr;
- (NSMutableArray *)decodePolylineLevel:(NSString *)encodedStr;
@end

@implementation DirectionsResponse

@synthesize statusCode  = _statusCode;
@synthesize route       = _route;

- (NSInteger)codeForString:(NSString *)statusString {

    if ([kDirectionsStatusCodeOk isEqualToString:statusString]) {
        return DirectionsStatusCodeOk;
    }
    else if ([kDirectionsStatusCodeNotFound isEqualToString:statusString]) {
        return DirectionsStatusCodeNotFound;
    }
    else if ([kDirectionsStatusCodeZeroResults isEqualToString:statusString]) {
        return DirectionsStatusCodeZeroResults;
    }
    else if ([kDirectionsStatusCodeMaxWaypointsExceeded isEqualToString:statusString]) {
        return DirectionsStatusCodeMaxWaypointsExceeded;
    }
    else if ([kDirectionsStatusCodeInvalidRequest isEqualToString:statusString]) {
        return DirectionsStatusCodeInvalidRequest;
    }
    else if ([kDirectionsStatusCodeOverQueryLimit isEqualToString:statusString]) {
        return DirectionsStatusCodeOverQueryLimit;
    }
    else if ([kDirectionsStatusCodeRequestDenied isEqualToString:statusString]) {
        return DirectionsStatusCodeRequestDenied;
    }
    else if ([kDirectionsStatusCodeUnknownError isEqualToString:statusString]) {
        return DirectionsStatusCodeUnknownError;
    }
    
    return -1;
}

- (id)initWithData:(NSData *)data
{
    if ((self = [super init]))
    {
        NSDictionary * JSON = [data objectFromJSONData];

        _statusCode = [self codeForString:[JSON valueForKey:@"status"]];
        
        NSArray * routes = [JSON valueForKey:@"routes"];
        
        if (routes && [routes count] > 0)
        {
            NSDictionary * route = [routes objectAtIndex:0];
            NSArray * legs = [route objectForKey:@"legs"];
            if (legs && [legs count] > 0)
            {
                NSDictionary * leg = [legs objectAtIndex:0];

                _route = [[QRoute alloc] init];
                
                _route->_distance       = [[leg valueForKeyPath:@"distance.text"] copy];
                _route->_duration       = [[leg valueForKeyPath:@"duration.text"] copy];
                _route->_startAddress   = [[leg valueForKeyPath:@"start_address"] copy];
                _route->_endAddress     = [[leg valueForKeyPath:@"end_address"] copy];
                _route->_startLocation  = [[CLLocation alloc] initWithLatitude:[[leg valueForKeyPath:@"start_location.lat"] doubleValue]
                                                                     longitude:[[leg valueForKeyPath:@"start_location.lng"] doubleValue]];
                _route->_endLocation    = [[CLLocation alloc] initWithLatitude:[[leg valueForKeyPath:@"end_location.lat"] doubleValue]
                                                                     longitude:[[leg valueForKeyPath:@"end_location.lng"] doubleValue]];
                
                NSMutableArray * steps = [NSMutableArray array];
                for (NSDictionary * step in [leg objectForKey:@"steps"]) {
                    QRouteStep * routeStep = [[QRouteStep alloc] initWithDictionary:step];
                    [steps addObject:routeStep];
                    [routeStep release];
                }
                
                _route->_steps = [[NSArray alloc] initWithArray:steps];

//                _levels = [self decodePolylineLevel:[route valueForKeyPath:@"overview_polyline.levels"]];
                NSMutableArray * points = [self decodePolyline:[route valueForKeyPath:@"overview_polyline.points"]];
                
                // Unpacking an array of NSValues into memory
                _route->_numberOfPoints = [points count];
                _route->_points = malloc(_route->_numberOfPoints * sizeof(CLLocationCoordinate2D));
                for (NSInteger i = 0; i < _route->_numberOfPoints; ++i) {
                    [[points objectAtIndex:i] getValue:(_route->_points + i)];
                }
            }
        }
    }
    return self;
}

- (void)dealloc {
    [_route release];
    [super dealloc];
}


// http://code.google.com/apis/maps/documentation/utilities/polylinealgorithm.html  

- (NSMutableArray *)decodePolylineLevel:(NSString *)encodedString
{
    NSMutableString * encoded = [[NSMutableString alloc] initWithString:encodedString];  

    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"  
                                options:NSLiteralSearch  
                                  range:NSMakeRange(0, encoded.length)];  
    
    NSInteger length = encoded.length;
    NSInteger index = 0;  
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];  
    while (index < length) {  
        NSInteger b;  
        NSInteger shift = 0;  
        NSInteger result = 0;  
        do {  
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5;  
        } while (b >= 0x20);  
        NSNumber *level = [[[NSNumber alloc] initWithFloat:result] autorelease];  
        [array addObject:level];  
    }  
    [encoded release];  
    return array;  
}  

// http://code.google.com/apis/maps/documentation/utilities/polylinealgorithm.html

- (NSMutableArray *)decodePolyline:(NSString *)encodedString
{
    NSMutableString * encoded = [[NSMutableString alloc] initWithString:encodedString];

    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, encoded.length)];
    
    NSMutableArray * points = [[NSMutableArray alloc] init];

    NSInteger lat = 0, lng = 0;
    NSInteger length = encoded.length;  
    NSInteger index = 0;

    while (index < length)
    {
        NSInteger b = 0, shift = 0, result = 0;  

        do
        {
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5;  
        }
        while (b >= 0x20);

        lat += ((result & 1) ? ~(result >> 1) : (result >> 1));  

        shift = 0, result = 0;

        do
        {
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5; 
        }
        while (b >= 0x20);
        
        lng += ((result & 1) ? ~(result >> 1) : (result >> 1));    

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat * 1e-5, lng * 1e-5);
        [points addObject:[NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)]];
    }  

    [encoded release];

    return [points autorelease];
}

@end


