//
//  MyProfileViewController.m
//  Shara
//
//  Created by Justin Rowe on 2/17/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "MyProfileViewController.h"
#import "SWRevealViewController.h"
#import "NSDictionary+Info.h"
#import "GetUserData.h"
#import <Parse/Parse.h>

@interface MyProfileViewController ()

@property (nonatomic, strong) GetUserData * sharedData;
@property (nonatomic, strong) NSString *userPhoto;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *currentLocation;

@end

@implementation MyProfileViewController

@synthesize profileImageView, profileEmailAddressLabel, profileLocationLabel, profileFirstNameLabel, profileLastNameLabel, editButton, userDictionary, sharedData, locationLabel, emailAddressLabel, userPhoto, firstName, lastName, emailAddress, currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:24.0f/255.0f green:52.0f/255.0f blue:66.0f/255.0f alpha:1.0f]];
    
    UILabel * buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    buttonLabel.font = [UIFont fontWithName:@"RaveParty Poster" size:14];
    buttonLabel.textColor = [UIColor colorWithRed:140.0f/255.0f green:169.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.adjustsFontSizeToFitWidth = YES;
    buttonLabel.text = @"Edit";
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView: buttonLabel];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    [revealButtonItem setTintColor:[UIColor colorWithRed:140.0f/255.0f green:169.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    PFQuery * userQuery = [PFUser query];
    NSArray *userArray = [userQuery findObjects];
    for (PFObject *object in userArray) {
        firstName = [NSString stringWithFormat:@"%@", [object objectForKey:@"userfirstName"]];
        lastName = [NSString stringWithFormat:@"%@", [object objectForKey:@"userLastName"]];
        emailAddress = [NSString stringWithFormat:@"%@", [object objectForKey:@"userEmailAddress"]];
        currentLocation = [NSString stringWithFormat:@"%@", [object objectForKey:@"userCurrentLocation"]];
        userPhoto = [NSString stringWithFormat:@"%@", [object objectForKey:@"userImage"]];
    }
    
    [self setProfileView];
}

- (void)setProfileView
{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userPhoto]]];
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
    [profileImageView setImage:image];
    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 80.0f, 80.0f, 80.0f)];
    newView.clipsToBounds = YES;
    newView.layer.cornerRadius = 40.0f;
    [newView addSubview:profileImageView];
    
    UIView * profileFirstNameLabelView = [[UIView alloc] initWithFrame:CGRectMake(120.0f, 80.0f, 180.0f, 38.0f)];
    [profileFirstNameLabelView setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:83.0f/255.0f blue:83.0f/255.0f alpha:0.5f]];
    [self.view addSubview:profileFirstNameLabelView];
    
    profileFirstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0.0f, 172.0f, 38.0f)];
    [profileFirstNameLabel setText:[NSString stringWithFormat:@"%@", firstName]];
    [profileFirstNameLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [profileFirstNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [profileFirstNameLabel setBackgroundColor:[UIColor clearColor]];
    
    UIView * profileLastNameLabelView = [[UIView alloc] initWithFrame:CGRectMake(120.0f, 120.0f, 180.0f, 38.0f)];
    [profileLastNameLabelView setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:83.0f/255.0f blue:83.0f/255.0f alpha:0.5f]];
    [self.view addSubview:profileLastNameLabelView];
    
    profileLastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0.0f, 172.0f, 38.0f)];
    [profileLastNameLabel setText:[NSString stringWithFormat:@"%@", lastName]];
    [profileLastNameLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [profileLastNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [profileLastNameLabel setBackgroundColor:[UIColor clearColor]];
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 180.0f, 110.0f, 14.0f)];
    [locationLabel setText:@"Location:"];
    [locationLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [locationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [locationLabel setTextAlignment:NSTextAlignmentLeft];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    
    UIView * profileLocationLabelView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 200.0f, 280.0f, 38.0f)];
    [profileLocationLabelView setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:83.0f/255.0f blue:83.0f/255.0f alpha:0.5f]];
    [self.view addSubview:profileLocationLabelView];

    profileLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0.0f, 272.0f, 38.0f)];
    [profileLocationLabel setText:[NSString stringWithFormat:@"%@", currentLocation]];
    [profileLocationLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [profileLocationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    [profileLocationLabel setBackgroundColor:[UIColor clearColor]];
    
    emailAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 250.0f, 110.0f, 14.0f)];
    [emailAddressLabel setText:@"Email Address:"];
    [emailAddressLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [emailAddressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [emailAddressLabel setTextAlignment:NSTextAlignmentLeft];
    [emailAddressLabel setBackgroundColor:[UIColor clearColor]];
    
    UIView * profileEmailAddressLabelView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 270.0f, 280.0f, 38.0f)];
    [profileEmailAddressLabelView setBackgroundColor:[UIColor colorWithRed:83.0f/255.0f green:83.0f/255.0f blue:83.0f/255.0f alpha:0.5f]];
    [self.view addSubview:profileEmailAddressLabelView];
    
    profileEmailAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 0.0f, 272.0f, 38.0f)];
    [profileEmailAddressLabel setText:[NSString stringWithFormat:@"%@", emailAddress]];
    [profileEmailAddressLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [profileEmailAddressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    [profileEmailAddressLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:newView];
    [profileFirstNameLabelView addSubview:profileFirstNameLabel];
    [profileLastNameLabelView addSubview:profileLastNameLabel];
    [self.view addSubview:locationLabel];
    [profileLocationLabelView addSubview:profileLocationLabel];
    [self.view addSubview:emailAddressLabel];
    [profileEmailAddressLabelView addSubview:profileEmailAddressLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
