//
//  SidebarViewController.m
//  Shara
//
//  Created by Justin Rowe on 2/13/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "HomeTableViewController.h"
#import "MyProfileViewController.h"
#import "MyFriendsViewController.h"
#import "SDLAppDelegate.h"
#import "AFNetworking.h"
#import "GetUserData.h"
#import "NSDictionary+Info.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface SidebarViewController ()

@property (nonatomic, strong) GetUserData * sharedUser;

@end

@implementation SidebarViewController

@synthesize backgroundImage, backgroundImageView, sharedUser, urlString, tokenCode, userDictionary, checkedIndexPath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:backgroundImageView];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    sharedUser = [[GetUserData alloc] init];
    sharedUser.delegate = self;
    [sharedUser getUserInfo];
}

- (void)setProfileView:(NSDictionary *)dictionary;
{
    NSDictionary *userInfoDictionary = [dictionary userDict];
    NSString *userPhoto = [userInfoDictionary userImage];
    NSString *firstName = [userInfoDictionary userFirstName];
    NSString *lastName = [userInfoDictionary userLastName];
    NSString *emailAddress = [userInfoDictionary userEmailAddress];
    NSString *currentLocation = [userInfoDictionary userLocation];
   
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userPhoto]]];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [imageView setImage:image];
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    newView.clipsToBounds = YES;
    newView.layer.cornerRadius = 18;
    [newView addSubview:imageView];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:newView];
    
    NSString * userNameString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    UILabel * userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [userNameLabel setText:userNameString];
    [userNameLabel setTextColor:[UIColor colorWithRed:140.0f/255.0f green:169.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [userNameLabel setFont:[UIFont fontWithName:@"RaveParty Poster" size:16]];
    [userNameLabel setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem * labelItem = [[UIBarButtonItem alloc] initWithCustomView:userNameLabel];
    
    NSArray *actionButtonItems = @[item, labelItem];
    self.navigationItem.leftBarButtonItems = actionButtonItems;
    
    PFUser * user = [PFUser currentUser];
    user[@"userImage"] = userPhoto;
    user[@"userfirstName"] = firstName;
    user[@"userLastName"] = lastName;
    user[@"userEmailAddress"] = emailAddress;
    user[@"userCurrentLocation"] = currentLocation;
    [user saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell.textLabel setFont:[UIFont fontWithName:@"RaveParty Poster" size:18]];
        cell.textLabel.textColor =[UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        //cell.contentView.backgroundColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:.60f];
	}
	
	if (row == 0)
	{
		cell.textLabel.text = @"Home";
	}
	else if (row == 1)
	{
		cell.textLabel.text = @"My Friends";
	}
	else if (row == 2)
	{
		cell.textLabel.text = @"My Profile";
	}
	else if (row == 3)
	{
		cell.textLabel.text = @"Settings";
	}
    else if (row == 4)
	{
		cell.textLabel.text = @"Log Out";
	}
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // We know the frontViewController is a NavigationController
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    NSInteger row = indexPath.row;
    
	// Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
	if (row == 0)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        if ( ![frontNavigationController.topViewController isKindOfClass:[HomeTableViewController class]] )
        {
			HomeTableViewController * homeTableViewController = [[HomeTableViewController alloc] init];
            homeTableViewController.title = @"Shara";
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeTableViewController];
			[revealController setFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}
	else if (row == 1)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
        if ( ![frontNavigationController.topViewController isKindOfClass:[MyFriendsViewController class]] )
        {
			MyFriendsViewController *myFriendsViewController = [[MyFriendsViewController alloc] init];
            myFriendsViewController.title = @"My Friends";
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:myFriendsViewController];
			[revealController setFrontViewController:navigationController animated:YES];
		}
        
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}
	else if (row == 2)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[MyProfileViewController class]] )
        {
			MyProfileViewController *myProfileViewController = [[MyProfileViewController alloc] init];
            myProfileViewController.title = @"My Profile";
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:myProfileViewController];
			[revealController setFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	} /*
	else if (row == 3)
	{
        [PFUser logOut];
        PFUser *currentUser = [PFUser currentUser];
        [(SDLAppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewController];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	} */
    else if (row == 4)
	{
        [PFUser logOut];
        PFUser *currentUser = [PFUser currentUser];
        [(SDLAppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewController];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	}
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
