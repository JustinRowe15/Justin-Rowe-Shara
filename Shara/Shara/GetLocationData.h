//
//  GetLocationData.h
//  Shara
//
//  Created by Justin Rowe on 2/14/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GetLocationDataDelegate <NSObject>

- (void)reloadLocationsView;
- (void)errorLogOut;

@end

@interface GetLocationData : NSObject

@property (nonatomic, strong) NSString *latitudeString;
@property (nonatomic, strong) NSString *longitudeString;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSDictionary *locationDictionary;

- (void)getLocationsAtCurrentLocation:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, weak)id<GetLocationDataDelegate>delegate;

@end
