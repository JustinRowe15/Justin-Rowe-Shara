//
//  SDLAppDelegate.m
//  Shara
//
//  Created by Justin Rowe on 2/6/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

static NSString * const defaultsFilterDistanceKey = @"filterDistance";
static NSString * const defaultsLocationKey = @"currentLocation";

#import "SDLAppDelegate.h"
#import "LoginViewController.h"
#import "HomeTableViewController.h"
#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "FSOAuth.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SDLAppDelegate()<SWRevealViewControllerDelegate>
@end

@implementation SDLAppDelegate

@synthesize filterDistance, currentLocation;
@synthesize revealViewController = _revealViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Load Parse application ID into database for analytics tracking
    [Parse setApplicationId:@"NDkOnizNpleZ0AnXosVZO5IjUqE1lrLQDA04Uvcb"
                  clientKey:@"itwZVJ6zEFq14Mhr3ff48YbOqC9zRYrmcZ89s2IB"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //Set Shara Navigation Bar Text Attributes
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.750f]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:0.8f]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:140.0f/255.0f green:169.0f/255.0f blue:165.0f/255.0f alpha:1.0f],
                                                           NSShadowAttributeName: shadow,
                                                           NSFontAttributeName: [UIFont fontWithName:@"RaveParty Poster" size:20]
                                                           }];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor colorWithRed:83.0f/255.0f green:83.0f/255.0f blue:83.0f/255.0f alpha:0.5f]];
    
    // Desired search radius:
	if ([userDefaults doubleForKey:defaultsFilterDistanceKey]) {
		// use the ivar instead of self.accuracy to avoid an unnecessary write to NAND on launch.
		filterDistance = [userDefaults doubleForKey:defaultsFilterDistanceKey];
	} else {
		// if we have no accuracy in defaults, set it to 3000 feet.
		self.filterDistance = 3000 * kNZLFeetToMeters;
	}
    
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		// Skip straight to the main view.
		[self presentMainViewController];
	} else {
		// Go to the welcome screen and have them log in or create an account.
		[self presentLoginViewController];
	}
    
    //Tracking Shara analytics in Parse
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)presentLoginViewController;
{
	// Go to the welcome screen and have them log in or create an account.
	self.loginViewController = [[LoginViewController alloc] init];
	self.loginViewController.title = @"Welcome to Shara";
    
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
	navController.navigationBarHidden = YES;
    
	self.viewController = navController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
	self.window.rootViewController = self.viewController;
}

-(void)presentMainViewController{
    // Go to the welcome screen and have them log in or create an account.
	HomeTableViewController *homeTableViewController = [[HomeTableViewController alloc] init];
    SidebarViewController * sideBarViewController = [[SidebarViewController alloc] init];
    
	homeTableViewController.title = @"Shara";
    
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeTableViewController];
    UINavigationController *sideBarNavController = [[UINavigationController alloc] initWithRootViewController:sideBarViewController     ];
	navController.navigationBarHidden = NO;
    sideBarNavController.navigationBarHidden = NO;
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:sideBarNavController frontViewController:navController];
    revealController.delegate = self;
    
	self.revealViewController = revealController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.revealViewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
	self.window.rootViewController = self.revealViewController;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self.loginViewController handleURL:url];
    [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Fetch started");
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    // Get Current Location from NSUserDefaults
    CLLocationCoordinate2D savedCurrentLocation;
    savedCurrentLocation.latitude = [standardDefaults floatForKey:@"locationLatitude"];
    savedCurrentLocation.longitude = [standardDefaults floatForKey:@"locationLongitude"];
    
    // GetWeather for current location
    GetLocationData * getLocations = [[GetLocationData alloc] init];
    [getLocations getLocationsAtCurrentLocation:savedCurrentLocation];
    
    // Set up Local Notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *now = [NSDate date];
    localNotification.fireDate = now;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"Fetch completed");
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
