//
//  NSDictionary+locationInfo.m
//  Shara
//
//  Created by Justin Rowe on 2/11/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "NSDictionary+Info.h"

@implementation NSDictionary (locationDictionary)

-(NSArray *)locationsArray
{
    NSDictionary *dict = [self objectForKey:@"response"];
    NSArray *ar = [dict objectForKey:@"groups"];
    NSDictionary * itemsDict = [ar objectAtIndex:0];
    return [itemsDict objectForKey:@"items"];
}

-(NSDictionary *)userDict
{
    NSDictionary *dict = [self objectForKey:@"response"];
    return [dict objectForKey:@"user"];
}

-(NSArray *)friendsArray
{
    NSDictionary *dict = [self objectForKey:@"response"];
    NSDictionary *user = [dict objectForKey:@"user"];
    NSDictionary *friends = [user objectForKey:@"friends"];
    NSArray *groups = [friends objectForKey:@"groups"];
    NSDictionary *itemsDict = [groups objectAtIndex:1];
    return [itemsDict objectForKey:@"items"];
}

-(NSString *)venueImage
{
    NSDictionary * venueDict = [self objectForKey:@"venue"];
    NSDictionary * imageDict = [venueDict objectForKey:@"featuredPhotos"];
    NSArray *ar = [imageDict objectForKey:@"items"];
    NSDictionary * itemsArray = [ar objectAtIndex:0];
    NSDictionary * sizesDict = [itemsArray objectForKey:@"sizes"];
    NSArray *ar2 = [sizesDict objectForKey:@"items"];
    NSDictionary * imageDict2 = [ar2 objectAtIndex:0];
    return [imageDict2 objectForKey:@"url"];
}

-(NSString *)venueName
{
    NSDictionary * venueDict = [self objectForKey:@"venue"];
    return [venueDict objectForKey:@"name"];
}

-(NSNumber *)venueCheckInCount
{
    NSDictionary * venueDict = [[self objectForKey:@"venue"] objectForKey:@"stats"];
    NSString *checkInCount = [venueDict objectForKey:@"checkinsCount"];
    NSNumber *n = [NSNumber numberWithInt:[checkInCount intValue]];
    return n;
}

-(NSString *)userImage
{
    return [self objectForKey:@"photo"];
}

-(NSString *)userFirstName
{
    return [self objectForKey:@"firstName"];
}

-(NSString *)userLastName
{
    return [self objectForKey:@"lastName"];
}

-(NSString *)userEmailAddress
{
    return [[self objectForKey:@"contact"] objectForKey:@"email"];
}

-(NSString *)userLocation
{
    return [self objectForKey:@"homeCity"];
}

-(NSString *)userFriendFirstName
{
    return [self objectForKey:@"firstName"];
}

-(NSString *)userFriendLastName
{
    return [self objectForKey:@"lastName"];
}

-(NSString *)userFriendHomeCity
{
    return [self objectForKey:@"homeCity"];
}

-(NSString *)userFriendImage
{
    return [self objectForKey:@"photo"];
}

-(NSString *)locationLatitude
{
    NSDictionary * venueDict = [self objectForKey:@"venue"];
    NSDictionary * imageDict = [venueDict objectForKey:@"location"];
    return [imageDict objectForKey:@"lat"];
}

-(NSString *)locationLongitude
{
    NSDictionary * venueDict = [self objectForKey:@"venue"];
    NSDictionary * imageDict = [venueDict objectForKey:@"location"];
    return [imageDict objectForKey:@"lng"];
}

@end
