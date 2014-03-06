//
//  NSDictionary+locationInfo.h
//  Shara
//
//  Created by Justin Rowe on 2/11/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (locationDictionary)

-(NSArray *)locationsArray;
-(NSDictionary *)userDict;
-(NSArray *)friendsArray;

-(NSString *)venueImage;
-(NSString *)venueName;
-(NSNumber *)venueCheckInCount;
-(NSString *)userImage;
-(NSString *)userFirstName;
-(NSString *)userLastName;
-(NSString *)userEmailAddress;
-(NSString *)userLocation;
-(NSString *)userFriendFirstName;
-(NSString *)userFriendLastName;
-(NSString *)userFriendHomeCity;
-(NSString *)userFriendImage;
-(NSString *)locationLatitude;
-(NSString *)locationLongitude;

@end
