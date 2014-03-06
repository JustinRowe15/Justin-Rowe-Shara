//
//  GetLocationData.m
//  Shara
//
//  Created by Justin Rowe on 2/14/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "GetLocationData.h"
#import <Parse/Parse.h>
#import "AFNetworking.h"
#import "NSDictionary+Info.h"
#import "SDLAppDelegate.h"

@interface GetLocationData ()

@property (nonatomic, strong) NSString *tokenCode;

@end

@implementation GetLocationData

@synthesize latitudeString, longitudeString, urlString, tokenCode, locationDictionary;

static GetLocationData * sharedDictionary;

- (void)getLocationsAtCurrentLocation:(CLLocationCoordinate2D)coordinate
{
    PFQuery * tokenQuery = [PFUser query];
    [tokenQuery whereKeyExists:@"fourSquareToken"];
    NSArray *tokenArray = [tokenQuery findObjects];
    for (PFObject *object in tokenArray) {
        tokenCode = [NSString stringWithFormat:@"%@", [object objectForKey:@"fourSquareToken"]];
        NSLog(@"The token code is: %@", tokenCode);
    }
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    longitudeString = [NSString stringWithFormat:@"%.8f", coordinate.longitude];
    latitudeString = [NSString stringWithFormat:@"%.8f", coordinate.latitude];
    
    urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%@,%@&oauth_token=%@&v=%ld%ld%ld&venuePhotos=1&limit=10&sortByDistance=1",latitudeString, longitudeString, tokenCode, (long)year, (long)month, (long)day];
    NSLog(@"Here is the URL String: %@", urlString);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.locationDictionary = (NSDictionary *)responseObject;
        //NSLog(@"JSON Data: %@", self.locationDictionary);
        [self.delegate reloadLocationsView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.delegate errorLogOut];
    }];
}

@end
