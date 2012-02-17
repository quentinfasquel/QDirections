//
//  DirectionsResponse.h
//  QDirections
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const kDirectionsStatusCodeOk;
extern NSString * const kDirectionsStatusCodeNotFound;
extern NSString * const kDirectionsStatusCodeZeroResults;
extern NSString * const kDirectionsStatusCodeMaxWaypointsExceeded;
extern NSString * const kDirectionsStatusCodeInvalidRequest;
extern NSString * const kDirectionsStatusCodeOverQueryLimit;
extern NSString * const kDirectionsStatusCodeRequestDenied;
extern NSString * const kDirectionsStatusCodeUnknownError;

typedef enum {
    DirectionsStatusCodeOk = 0,
    DirectionsStatusCodeNotFound,
    DirectionsStatusCodeZeroResults,
    DirectionsStatusCodeMaxWaypointsExceeded,
    DirectionsStatusCodeInvalidRequest,
    DirectionsStatusCodeOverQueryLimit,
    DirectionsStatusCodeRequestDenied,
    DirectionsStatusCodeUnknownError
} GeocodeStatusCode;

@class QRoute;

@interface DirectionsResponse : NSObject {
    NSInteger   _statusCode;
    QRoute * _route;
}

@property (nonatomic, readonly) NSInteger   statusCode;
@property (nonatomic, readonly) QRoute * route;

- (id)initWithData:(NSData *)data;

@end
