//
//  MapAnnotation.h
//  Shara
//
//  Created by Justin Rowe on 2/25/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
