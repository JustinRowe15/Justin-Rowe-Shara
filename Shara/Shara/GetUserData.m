//
//  GetUserData.m
//  Shara
//
//  Created by Justin Rowe on 2/16/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "GetUserData.h"
#import "AFNetworking.h"
#import "NSDictionary+Info.h"
#import <Parse/Parse.h>

@implementation GetUserData

@synthesize urlString, tokenCode, userDictionary;

- (void)getUserInfo
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
    
    urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/users/self?oauth_token=%@&v=%ld%ld%ld&venuePhotos=1&limit=10&sortByDistance=1", tokenCode, (long)year, (long)month, (long)day];
    NSLog(@"Here is the URL String: %@", urlString);
    
    [self parseJSONData:urlString];
}

- (void)parseJSONData:(NSString *)string
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        userDictionary = (NSDictionary *)responseObject;
        //NSDictionary *userInfoDictionary = [self.userDictionary userArray];
        //NSLog(@"GetUserData Array: %@", userInfoDictionary);
        [self.delegate setProfileView:self.userDictionary];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
