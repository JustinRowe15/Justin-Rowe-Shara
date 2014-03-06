//
//  NewUserViewController.h
//  Shara
//
//  Created by Justin Rowe on 2/16/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewUserViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) NSString *currentAccessCode;
@property (strong, nonatomic) NSString *welcomeString;
@property (strong, nonatomic) NSString *loginString;
@property (strong, nonatomic) NSString *userString;
@property (strong, nonatomic) NSString *forgotString;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *loginLabel;
@property (strong, nonatomic) IBOutlet UILabel *forgotLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UIButton *fourSquareButton;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) UIImageView *fourSquareLogoView;
@property (strong, nonatomic) UIImage *fourSquareLogo;

+ (NewUserViewController *)sharedAccessCode;
- (void)fourSquareLogin;
- (void)handleURL:(NSURL *)url;

@end
