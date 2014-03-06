//
//  MapLocationsViewController.m
//  Shara
//
//  Created by Justin Rowe on 2/24/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "MapLocationsViewController.h"
#import "HomeTableViewController.h"
#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "MapAnnotation.h"
#import "NSDictionary+Info.h"
#import "GetLocationData.h"
#import "SDLAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface MapLocationsViewController ()

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) GetLocationData * sharedLocation;

@end

@implementation MapLocationsViewController

@synthesize mapView, locationManager, latitudeString, longitudeString, sharedLocation, nameString;

NSUserDefaults *standardDefaults;
CLLocationCoordinate2D latLong;
MKCoordinateRegion region;
MKCoordinateSpan span;

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
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
    [mapView setMapType:MKMapTypeStandard];
    [self.view addSubview:mapView];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mapButton.frame = CGRectMake(244, 25, 66, 44);
    [mapButton setTitle:@"Back" forState:UIControlStateNormal];
    [mapButton setBackgroundColor:[UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:0.8f]];
    [mapButton setTitleColor:[UIColor colorWithRed:140.0f/255.0f green:169.0f/255.0f blue:165.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [mapButton.titleLabel setFont:[UIFont fontWithName:@"RaveParty Poster" size:16.0f]];
    [mapButton addTarget:self action:@selector(showHomeView) forControlEvents:UIControlEventTouchUpInside];
    mapButton.layer.cornerRadius = 10; // this value vary as per your desire
    mapButton.clipsToBounds = YES;
    [mapView addSubview:mapButton];
    
	locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    [self addGestureRecognizerToMapView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    [self getLocation:location];
    latLong.latitude = location.coordinate.latitude;
    latLong.longitude = location.coordinate.longitude;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = latLong;
    [mapView setRegion:region animated:YES];
    
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

- (void)reloadLocationsView
{
    __block NSArray *annotations;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        annotations = [self parseJSONLocations];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self.mapView addAnnotations:annotations];
        });
    });
}

- (void)errorLogOut
{
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    [(SDLAppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewController];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addGestureRecognizerToMapView
{
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5; //
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MapAnnotation *annotation = [[MapAnnotation alloc]init];
    annotation.coordinate = touchMapCoordinate;
    //annotation.subtitle = @"Subtitle";
    annotation.title = @"Title";
    
    [self.mapView addAnnotation:annotation];
}

- (NSMutableArray *)parseJSONLocations
{
    NSMutableArray *locationInfo = [[NSMutableArray alloc]init];
    NSArray *upcomingLocations = [sharedLocation.locationDictionary locationsArray];
    for (NSDictionary *fourSquareLocations in upcomingLocations) {
        nameString = [fourSquareLocations venueName];
        latitudeString = [fourSquareLocations locationLatitude];
        longitudeString = [fourSquareLocations locationLongitude];
            
        MapAnnotation *temp = [[MapAnnotation alloc]init];
        [temp setTitle:nameString];
        [temp setCoordinate:CLLocationCoordinate2DMake([latitudeString floatValue], [longitudeString floatValue])];
        [locationInfo addObject:temp];
    }
    
    return locationInfo;
}

-(IBAction)showHomeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
