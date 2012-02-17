//
//  HTTPGeocoder.h
//  QDirections
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NSObject+DirectionsRequest.h"

extern NSString * const DirectionsRequestOutputJSON;
extern NSString * const DirectionsRequestOutputXML;

/**
 * Google Directions Request
 * http://code.google.com/apis/maps/documentation/directions/#DirectionsRequests
 *
 */

extern NSString * const DirectionsTravelModeDriving;
extern NSString * const DirectionsTravelModeWalking;
extern NSString * const DirectionsTravelModeBicycling;

// TODO: waypoints
// TODO: alternatives
// TODO: units
// TODO: avoid : tolls, highways

@interface DirectionsRequest : NSOperation {
    id                      _delegate;
    NSURL *                 _URL;
    NSURLConnection *       _connection;
    NSMutableData *         _responseData;
    NSString *              _origin;
    NSString *              _destination;
    NSString *              _mode;
    NSString *              _region;
    NSString *              _language;
    BOOL                    _executing;
    BOOL                    _finished;
    BOOL                    _secure;
}

@property (nonatomic, retain)   id                      delegate;
@property (nonatomic, readonly) NSURL *                 URL;
@property (nonatomic, readonly) NSMutableData *         responseData;
@property (nonatomic, copy)     NSString *              origin;
@property (nonatomic, copy)     NSString *              destination;
@property (nonatomic, copy)     NSString *              mode;
@property (nonatomic, copy)     NSString *              region;
@property (nonatomic, copy)     NSString *              language;
@property (nonatomic, assign)   BOOL                    secure;

- (id)initFromAddress:(NSString *)fromAddress toAddress:(NSString *)address delegate:(id)aDelegate;
//- (id)initFromAdress:(NSString *)fromAddress toCoordinate:(CLLocationCoordinate2D)toCoordinate delegate:(id)aDelegate;
- (id)initFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate delegate:(id)aDelegate;
//- (id)initFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toAddress:(NSString *)toAddress delegate:(id)aDelegate;

@end
