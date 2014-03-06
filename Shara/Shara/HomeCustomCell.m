//
//  HomeCustomCell.m
//  Shara
//
//  Created by Justin Rowe on 2/24/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "HomeCustomCell.h"

@implementation HomeCustomCell

@synthesize venueLabel, personCountLabel, personIcon, quotesCountLabel, quotesIcon, locationIcon, checkInCountLabel, backgroundImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //Venue Name Label Attributes
        venueLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 28.0f, 300.0f, 20.0f)];
        venueLabel.tag = 1;
        venueLabel.font = [UIFont fontWithName:@"RaveParty Poster" size:18];
        venueLabel.textAlignment = NSTextAlignmentLeft;
        venueLabel.textColor = [UIColor whiteColor];
        //venueLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        
        //Person Count Label Attributes
        personCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 28.0f, 30.0f, 20.0f)];
        personCountLabel.tag = 2;
        personCountLabel.font = [UIFont fontWithName:@"RaveParty Poster" size:14];
        personCountLabel.textAlignment = NSTextAlignmentLeft;
        personCountLabel.textColor = [UIColor whiteColor];
        personCountLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        
        //Set Person Icon Attributes
        personIcon = [[UIImageView alloc] initWithFrame:CGRectMake(37.0f, 56.0f, 20.0f, 20.0f)];
        personIcon.image = [UIImage imageNamed:@"person.png"];
        personIcon.tag = 5;
        
        //Quotes Count Label Attributes
        quotesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 28.0f, 30.0f, 20.0f)];
        quotesCountLabel.tag = 3;
        quotesCountLabel.font = [UIFont fontWithName:@"RaveParty Poster" size:14];
        quotesCountLabel.textAlignment = NSTextAlignmentRight;
        quotesCountLabel.textColor = [UIColor whiteColor];
        quotesCountLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        
        //Set Quotes Icon Attributes
        quotesIcon = [[UIImageView alloc] initWithFrame:CGRectMake(97.0f, 56.0f, 20.0f, 20.0f)];
        quotesIcon.image = [UIImage imageNamed:@"chat.png"];
        quotesIcon.tag = 6;
        
        //Total Check In's Count Label Attributes
        checkInCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(122.0f, 28.0f, 50.0f, 20.0f)];
        checkInCountLabel.tag = 4;
        checkInCountLabel.font = [UIFont fontWithName:@"RaveParty Poster" size:14];
        checkInCountLabel.textAlignment = NSTextAlignmentRight;
        checkInCountLabel.textColor = [UIColor whiteColor];
        checkInCountLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        
        //Set Location Icon Attributes
        locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(174.0f, 56.0f, 20.0f, 20.0f)];
        locationIcon.image = [UIImage imageNamed:@"location.png"];
        locationIcon.tag = 7;
        
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
