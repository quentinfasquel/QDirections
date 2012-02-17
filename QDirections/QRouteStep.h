//
//  QRouteStep.h
//  QDirections
//
//  Created by Quentin Fasquel on 29/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface QRouteStep : NSObject {
    NSDictionary * _dictionary;
    CLLocation * _startLocation;
    CLLocation * _endLocation;
}

@property (nonatomic, readonly) NSString * distance;
@property (nonatomic, readonly) NSString * duration;
@property (nonatomic, readonly) NSString * htmlInstructions;
@property (nonatomic, readonly) NSString * travelMode;
@property (nonatomic, readonly) CLLocation * startLocation;
@property (nonatomic, readonly) CLLocation * endLocation;

@end
