//
//  QDirections.m
//  QDirections
//
//  Created by Quentin Fasquel on 31/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "QDirections.h"
#import "DirectionsRequest.h"
#import "DirectionsResponse.h"

@interface QDirections ()
@end

@implementation QDirections
@synthesize delegate = _delegate;

- (void)dealloc {
    [_request release];
    [_response release];
    [super dealloc];
}

#pragma mark - Managing Directions Request

- (void)cancel {
    if (_request) {
        [_request cancel];
        [_request release], _request = nil;
    }
}

- (BOOL)isExecuting {
    return [_request isExecuting];
}

- (void)getDirectionsFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate {
    [self cancel];

    _request = [[DirectionsRequest alloc] initFromCoordinate:fromCoordinate toCoordinate:toCoordinate delegate:self];

    if ([self.delegate respondsToSelector:@selector(directionsShouldUseSecureConnection:)]) {
        _request.secure = [self.delegate directionsShouldUseSecureConnection:self];
    }

    [_request start];
}

- (void)getDirectionsFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress {
    [self cancel];

    _request = [[DirectionsRequest alloc] initFromAddress:fromAddress toAddress:toAddress delegate:self];

    if ([_delegate respondsToSelector:@selector(directionsShouldUseSecureConnection:)]) {
        _request.secure = [_delegate directionsShouldUseSecureConnection:self];
    }

    [_request start];
}


#pragma mark - Managing Internal Request

- (void)directionsRequestDidFinishLoading:(DirectionsRequest *)request {
    _response = [[DirectionsResponse alloc] initWithData:request.responseData];
    
    if ([_delegate respondsToSelector:@selector(directions:didFindRoute:)]) {
        [_delegate directions:self didFindRoute:_response.route];
    }
    
    [_response release], _response = nil;
    [_request release], _request = nil;
}

- (void)directionsRequest:(DirectionsRequest *)request didFailWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(directions:didFailWithError:)]) {
        [_delegate directions:self didFailWithError:error];
    }

    [_request release], _request = nil;
}


@end
