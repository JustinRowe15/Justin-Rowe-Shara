//
//  MyFriendsViewController.h
//  Shara
//
//  Created by Justin Rowe on 2/18/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetUserData.h"

@interface MyFriendsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, GetUserDataDelegate>

@property (nonatomic, strong) NSArray *userFriendsArray;
@property (nonatomic, strong) NSDictionary *userFriendsDictionary;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UIImageView *friendImage;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) NSMutableDictionary *sections;

- (void)setProfileView:(NSDictionary *)dictionary;

@end
