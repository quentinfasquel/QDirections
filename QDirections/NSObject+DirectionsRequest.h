//
//  NSObject+DirectionsRequest.h
//  QDirections
//
//  Created by Quentin Fasquel on 29/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

@class DirectionsRequest;

@interface NSObject (DirectionsRequest)
- (void)directionsRequestDidFinishLoading:(DirectionsRequest *)request;
- (void)directionsRequest:(DirectionsRequest *)request didFailWithError:(NSError *)error;
@end
