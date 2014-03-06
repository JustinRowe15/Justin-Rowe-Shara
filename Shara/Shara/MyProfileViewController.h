//
//  MyProfileViewController.h
//  Shara
//
//  Created by Justin Rowe on 2/17/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetUserData.h"

@interface MyProfileViewController : UIViewController

@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *profileFirstNameLabel;
@property (nonatomic, strong) UILabel *profileLastNameLabel;
@property (nonatomic, strong) UILabel *profileLocationLabel;
@property (nonatomic, strong) UILabel *profileEmailAddressLabel;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) NSDictionary *userDictionary;

@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *emailAddressLabel;

- (void)setProfileView;

@end
