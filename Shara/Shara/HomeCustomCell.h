//
//  HomeCustomCell.h
//  Shara
//
//  Created by Justin Rowe on 2/24/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCustomCell : UITableViewCell

@property (strong, nonatomic) UILabel *venueLabel;
@property (strong, nonatomic) UILabel *personCountLabel;
@property (strong, nonatomic) UILabel *quotesCountLabel;
@property (strong, nonatomic) UILabel *checkInCountLabel;
@property (strong, nonatomic) UIImageView *personIcon;
@property (strong, nonatomic) UIImageView *quotesIcon;
@property (strong, nonatomic) UIImageView *locationIcon;
@property (strong, nonatomic) UIImageView *backgroundImage;

@end
