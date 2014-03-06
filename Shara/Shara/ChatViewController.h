//
//  ChatViewController.h
//  Shara
//
//  Created by Justin Rowe on 2/6/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ChatViewController : UIViewController

@property (nonatomic, strong) PFObject * chatroom;

@end
