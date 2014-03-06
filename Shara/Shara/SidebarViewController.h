//
//  SidebarViewController.h
//  Shara
//
//  Created by Justin Rowe on 2/13/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetUserData.h"

@interface SidebarViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, GetUserDataDelegate>

@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
@property (strong, nonatomic) UIImageView *backgroundImage;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) NSIndexPath *checkedIndexPath;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *tokenCode;
@property (nonatomic, strong) NSDictionary *userDictionary;

- (void)setProfileView:(NSDictionary *)dictionary;

@end
