//
//  QRoute.h
//  QDirections
//
//  Created by Quentin Fasquel on 01/08/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface QRoute : NSObject {
@public
    NSString * _distance;
    NSString * _duration;
    NSString * _startAddress;
    NSString * _endAddress;
    CLLocation * _startLocation; // CLLocationCoordinate2D
    CLLocation * _endLocation; // CLLocationCoordinate2D
    CLLocationCoordinate2D * _points;
    NSUInteger _numberOfPoints;
//    NSMutableArray * _levels;   
    NSArray * _steps;
}

@property (nonatomic, readonly) NSString * distance;
@property (nonatomic, readonly) NSString * duration;
@property (nonatomic, readonly) NSString * startAddress;
@property (nonatomic, readonly) NSString * endAddress;
@property (nonatomic, readonly) CLLocation * startLocation;
@property (nonatomic, readonly) CLLocation * endLocation;
@property (nonatomic, readonly) CLLocationCoordinate2D * points;
@property (nonatomic, readonly) NSUInteger numberOfPoints;

@property (nonatomic, readonly) NSArray * steps;
//@property (nonatomic, readonly) NSArray * levels;

@end
