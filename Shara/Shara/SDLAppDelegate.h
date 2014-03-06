//
//  SDLAppDelegate.h
//  Shara
//
//  Created by Justin Rowe on 2/6/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class LoginViewController;
@class SWRevealViewController;

@interface SDLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic, strong) CLLocation * currentLocation;
@property (nonatomic, assign) CLLocationAccuracy filterDistance;
@property (strong, nonatomic) LoginViewController * loginViewController;
@property (strong, nonatomic) SWRevealViewController * revealViewController;

- (void)presentLoginViewController;
- (void)presentMainViewController;

@end
