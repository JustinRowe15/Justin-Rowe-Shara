//
//  HomeTableViewController.m
//  Shara
//
//  Created by Justin Rowe on 2/10/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "HomeTableViewController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "NSDictionary+Info.h"
#import "SDLAppDelegate.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MapLocationsViewController.h"
#import "GetLocationData.h"
#import "HomeCustomCell.h"
#import <Parse/Parse.h>

@interface HomeTableViewController ()

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) GetLocationData * sharedLocation;

@end

@implementation HomeTableViewController

@synthesize latitudeString, longitudeString, tokenCode, sidebarButton, sharedLocation, tableBackgroundImageView;

dispatch_queue_t imageQueue_;
BOOL locationCalled = 0;
NSUserDefaults *standardDefaults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        imageQueue_ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:tableBackgroundImageView];
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [self setUpRefreshControl];
    self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    [revealButtonItem setTintColor:[UIColor colorWithRed:140.0f/255.0f green:169.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *mapButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(showMapView)];
    [mapButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"RaveParty Poster" size:16.0f]} forState:UIControlStateNormal];
    [mapButtonItem setTintColor:[UIColor colorWithRed:140.0f/255.0f green:169.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    self.navigationItem.rightBarButtonItem = mapButtonItem;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self receiveAllData];
}

- (void)setUpRefreshControl
{
    locationCalled = 0;
    [self.locationManager startUpdatingLocation];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor: [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:.60f]];
    [refreshControl addTarget:self action:@selector(receiveAllData) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

- (void)receiveAllData
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    [self getLocation:location];
    locationCalled = 1;
    
    standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setFloat:location.coordinate.latitude forKey:@"locationLatitude"];
    [standardDefaults setFloat:location.coordinate.longitude forKey:@"locationLongitude"];
}

- (void)getLocation:(CLLocation *)location
{
    CLLocationCoordinate2D currentLocation = location.coordinate;
    sharedLocation = [[GetLocationData alloc] init];
    sharedLocation.delegate = self;
    [sharedLocation getLocationsAtCurrentLocation:currentLocation];
}

-(void)reloadLocationsView
{
    [self.tableView reloadData];
}

-(IBAction)showMapView
{
    MapLocationsViewController *mapLocationViewController = [[MapLocationsViewController alloc] init];
    [self presentViewController:mapLocationViewController animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *upcomingLocations = [sharedLocation.locationDictionary locationsArray];
    return [upcomingLocations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (HomeCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HomeCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.venueLabel = nil;
    cell.personCountLabel = nil;
    cell.quotesCountLabel = nil;
    cell.checkInCountLabel = nil;
    
    NSDictionary * fourSquareLocations;
    NSArray *upcomingLocations = [sharedLocation.locationDictionary locationsArray];
    fourSquareLocations = [upcomingLocations objectAtIndex:indexPath.row];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self.refreshControl endRefreshing];
    
    if (cell == nil)
    {
        cell = [[HomeCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:cell.venueLabel];
        [cell.contentView addSubview:cell.personCountLabel];
        [cell.contentView addSubview:cell.personIcon];
        [cell.contentView addSubview:cell.quotesCountLabel];
        [cell.contentView addSubview:cell.quotesIcon];
        [cell.contentView addSubview:cell.checkInCountLabel];
        [cell.contentView addSubview:cell.locationIcon];
    }
    
    dispatch_async(imageQueue_, ^(void) {
        NSString *photoPath = [fourSquareLocations venueImage];
        NSData* imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: photoPath]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            cell.backgroundImage.backgroundColor = [UIColor clearColor];
            cell.backgroundImage.opaque = NO;
            cell.backgroundImage.tag = 8;
            cell.backgroundView = cell.backgroundImage;
            cell.backgroundImage.image = image;
            cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
            cell.contentView.backgroundColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:.60f];
            [cell setNeedsLayout];
        });
    });
    
    cell.venueLabel = (UILabel *)[cell.contentView viewWithTag:1];
    [cell.venueLabel setText:[fourSquareLocations venueName]];
    cell.personCountLabel = (UILabel *)[cell.contentView viewWithTag:2];
    [cell.personCountLabel setText:@"200"];
    cell.quotesCountLabel = (UILabel *)[cell.contentView viewWithTag:3];
    [cell.quotesCountLabel setText:@"330"];
    cell.checkInCountLabel = (UILabel *)[cell.contentView viewWithTag:4];
    [cell.checkInCountLabel setText:[NSString stringWithFormat:@"%@",[fourSquareLocations venueCheckInCount]]];
    cell.personIcon = (UIImageView *)[cell.contentView viewWithTag:5];
    cell.quotesIcon = (UIImageView *)[cell.contentView viewWithTag:6];
    cell.locationIcon = (UIImageView *)[cell.contentView viewWithTag:7];
    cell.backgroundImage = (UIImageView *)[cell.backgroundView viewWithTag:8];
    
    return cell;
}

- (void)errorLogOut
{
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    [(SDLAppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewController];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
