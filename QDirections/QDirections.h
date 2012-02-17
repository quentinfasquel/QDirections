//
//  QDirections.h
//  QDirections
//
//  Created by Quentin Fasquel on 31/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "QRoute.h"

@class DirectionsRequest;
@class DirectionsResponse;
@protocol QDirectionsDelegate;

@interface QDirections : NSObject {
@private
    DirectionsRequest * _request;
    DirectionsResponse * _response;
}

@property (nonatomic, assign) id <QDirectionsDelegate> delegate;
@property (nonatomic, readonly, getter = isExecuting) BOOL executing;

- (void)getDirectionsFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate;
- (void)getDirectionsFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress;

- (void)cancel;

@end


@protocol QDirectionsDelegate <NSObject>
- (void)directions:(QDirections *)directions didFindRoute:(QRoute *)route;
- (void)directions:(QDirections *)directions didFailWithError:(NSError *)error;
@optional
- (BOOL)directionsShouldUseSecureConnection:(QDirections *)directions;
@end
