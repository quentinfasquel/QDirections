//
//  DirectionsRequest.m
//  QDirections
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "DirectionsRequest.h"
#import "NSObject+DirectionsRequest.h"

// TODO: use https
static NSString * DirectionsURL               = @"http://maps.googleapis.com/maps/api/directions/%@?%@";
static NSString * DirectionsSecureURL         = @"https://maps.googleapis.com/maps/api/directions/%@?%@";

NSString * const DirectionsRequestOutputJSON    = @"json";
NSString * const DirectionsRequestOutputXML     = @"xml";
NSString * const DirectionsTravelModeDriving    = @"driving";
NSString * const DirectionsTravelModeWalking    = @"walking";
NSString * const DirectionsTravelModeBicycling  = @"bicycling";


@interface DirectionsRequest ()
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@end


@implementation DirectionsRequest

@synthesize delegate        = _delegate;
@synthesize URL             = _URL;
@synthesize responseData    = _responseData;
@synthesize origin          = _origin;
@synthesize destination     = _destination;
@synthesize mode            = _mode;
@synthesize region          = _region;
@synthesize language        = _language;
@synthesize secure          = _secure;

#pragma mark -
#pragma mark Directions or Reverse Directions

- (id)initFromAddress:(NSString *)fromAddress
           toAddress:(NSString *)toAddress
            delegate:(id)aDelegate
{
    if ((self = [super init]))
    {
        _delegate = [aDelegate retain];
        _finished = NO;
        _executing = NO;
        self.origin = fromAddress;
        self.destination = toAddress;
    }
    return self;
}
- (id)initFromCoordinate:(CLLocationCoordinate2D)fromCoordinate
            toCoordinate:(CLLocationCoordinate2D)toCoordinate
                delegate:(id)aDelegate
{
    if ((self = [super init]))
    {
        _delegate = [aDelegate retain];
        _finished = NO;
        _executing = NO;
        
        self.origin = [NSString stringWithFormat:@"%f,%f",
                       fromCoordinate.latitude,
                       fromCoordinate.longitude];

        self.destination = [NSString stringWithFormat:@"%f,%f",
                            toCoordinate.latitude,
                            toCoordinate.longitude];        
    }
    return self;
}

- (void)dealloc {
    [_delegate release];
    [_origin release];
    [_destination release];
    [_mode release];
    [_region release];
    [_language release];
    [_URL release];
    [_connection release];
    [_responseData release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessing Request Attributes

- (NSString *)parameters {
    // Exception : Needs address or coordinate !
    NSMutableString * parameters = [NSMutableString string];
    
    [parameters appendFormat:@"origin=%@", _origin];
    [parameters appendFormat:@"&destination=%@", _destination];
    
    if (_mode) {
        [parameters appendFormat:@"&mode=%@", _mode];
    }
    
    if (_region) {
        [parameters appendFormat:@"&region=%@", _region];
    }
    
    if (_language) {
        [parameters appendFormat:@"&language=%@", _language];
    }
    
    // sensor because is a device
    [parameters appendString:@"&sensor=false"];
    
    return parameters;
}

- (NSURL *)URL {
    if (!_URL) {
        _URL = [[NSURL alloc] initWithString:
                [[NSString stringWithFormat:
                  (_secure ? DirectionsSecureURL : DirectionsURL),
                  DirectionsRequestOutputJSON,
                  [self parameters]]
                 stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding]];
    }
    return _URL;
}

#pragma mark -
#pragma mark NSOperation

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isExecuting {
    return _executing;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];        
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)cancel {
    [_connection cancel];

    [self willChangeValueForKey:@"isCancelled"];
    [super cancel];
    [self didChangeValueForKey:@"isCancelled"];    
}

- (void)start {

    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }

    self.executing = YES;

    _connection = [[NSURLConnection alloc]
                   initWithRequest:[NSURLRequest requestWithURL:self.URL]
                   delegate:self];
    [_connection start];
}

- (void)terminate {
    [_connection release], _connection = nil;
    [_URL release], _URL = nil;
    self.executing = NO;
    self.finished = YES;
}

#pragma mark -
#pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_responseData) {
        _responseData = [[NSMutableData alloc] init];
    }
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_delegate performSelector:@selector(directionsRequest:didFailWithError:) withObject:self withObject:error];
    [self terminate];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_delegate performSelector:@selector(directionsRequestDidFinishLoading:) withObject:self];
    [self terminate];
}

@end
