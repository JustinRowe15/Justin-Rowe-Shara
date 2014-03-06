//
//  MyFriendsViewController.m
//  Shara
//
//  Created by Justin Rowe on 2/18/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "SWRevealViewController.h"
#import "GetUserData.h"
#import "NSDictionary+Info.h"
#import "MBProgressHUD.h"

@interface MyFriendsViewController ()

@property (nonatomic, strong) GetUserData * sharedData;
@property (nonatomic, strong) NSDictionary * friendsDict;
@property (nonatomic, strong) NSArray * friendsList;

@end

@implementation MyFriendsViewController

@synthesize sharedData, userFriendsArray, nameLabel, locationLabel, friendImage, userFriendsDictionary, backgroundImageView, friendsDict, friendsList, sections;

dispatch_queue_t imageQueue_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:backgroundImageView];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    [revealButtonItem setTintColor:[UIColor colorWithRed:140.0f/255.0f green:169.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    sharedData = [[GetUserData alloc] init];
    sharedData.delegate = self;
    [sharedData getUserInfo];
}

- (void)setProfileView:(NSDictionary *)dictionary;
{
    userFriendsDictionary = dictionary;
    friendsList = [userFriendsDictionary friendsArray]; // NSArray
    
    sections = [[NSMutableDictionary alloc] init];
    BOOL found;
    for (NSDictionary *temp in friendsList){
        NSString *c = [[temp objectForKey:@"firstName"] substringToIndex:1];
        found = NO;
        for (NSString *str in [sections allKeys]) {
            if ([str isEqualToString:c]) {
                found = YES;
            }
        }
        if (!found) {
            [sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    for (NSDictionary *temp in friendsList){
        [[sections objectForKey:[[temp objectForKey:@"firstName"] substringToIndex:1]] addObject:temp];
    }
    for (NSString *key in [sections allKeys])
    {
        [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
    }

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *indexArray = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    return indexArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[sections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    friendImage = nil;
    nameLabel = nil;
    locationLabel = nil;
    friendsDict = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]; // NSDictionary
    //NSLog(@"Friends Dict: %@", friendsDict);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(72.0f, 4.0f, 260.0f, 18.0f)];
        nameLabel.tag = 2;
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:nameLabel];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(72.0f, 26.0f, 260.0f, 12.0f)];
        locationLabel.tag = 3;
        locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        locationLabel.textAlignment = NSTextAlignmentLeft;
        locationLabel.textColor = [UIColor whiteColor];
        locationLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:locationLabel];
    }
    
    dispatch_async(imageQueue_, ^(void) {
        NSString *photoPath = [friendsDict userFriendImage];
        NSData* imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: photoPath]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 44.0f, 44.0f)];
            newView.clipsToBounds = YES;
            newView.layer.cornerRadius = 22;
            [cell.contentView addSubview:newView];
            
            friendImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
            friendImage.backgroundColor = [UIColor clearColor];
            friendImage.opaque = NO;
            friendImage.tag = 1;
            [friendImage setImage:image];
            [newView addSubview:friendImage];
            [cell setNeedsLayout];
        });
    });
    
    friendImage = (UIImageView *)[cell.contentView viewWithTag:1];
    nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@", [friendsDict userFriendFirstName], [friendsDict userFriendLastName]]];
    locationLabel= (UILabel *)[cell.contentView viewWithTag:3];
    [locationLabel setText:[friendsDict userFriendHomeCity]];
    
    return cell;
}
@end
