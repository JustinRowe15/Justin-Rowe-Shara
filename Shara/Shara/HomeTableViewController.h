//
//  HomeTableViewController.h
//  Shara
//
//  Created by Justin Rowe on 2/10/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GetLocationData.h"

@interface HomeTableViewController : UITableViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, GetLocationDataDelegate>

@property (nonatomic, strong) NSString *latitudeString;
@property (nonatomic, strong) NSString *longitudeString;
@property (nonatomic, strong) NSString *tokenCode;
@property (strong, nonatomic) UIImageView *tableBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (void)receiveAllData;
- (void)setUpRefreshControl;
- (IBAction)showMapView;

@end
