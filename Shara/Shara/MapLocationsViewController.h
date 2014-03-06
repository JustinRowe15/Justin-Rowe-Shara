//
//  MapLocationsViewController.h
//  Shara
//
//  Created by Justin Rowe on 2/24/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GetLocationData.h"

@interface MapLocationsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, GetLocationDataDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSString *latitudeString;
@property (nonatomic, strong) NSString *longitudeString;

@end
