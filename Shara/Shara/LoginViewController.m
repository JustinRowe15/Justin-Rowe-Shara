//
//  LoginViewController.m
//  Shara
//
//  Created by Justin Rowe on 2/16/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "LoginViewController.h"
#import "FSOAuth.h"
#import "SDLAppDelegate.h"
#import "NewUserViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (nonatomic) NSString *latestAccessCode;
- (void)processFieldEntries;

@end

@implementation LoginViewController

@synthesize loginLabel, loginString, welcomeLabel, welcomeString, forgotLabel, forgotString, fourSquareButton, fourSquareLogo, fourSquareLogoView, currentAccessCode, latestAccessCode, usernameField, passwordField, userString, userLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

static LoginViewController * sharedAccessCode = nil;

+ (LoginViewController *)sharedAccessCode
{
    @synchronized(self){
        if (sharedAccessCode == nil){
            sharedAccessCode = [[self alloc] init];
        }
    }
    
    return sharedAccessCode;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setting background image here
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"welcome.png"] drawInRect:self.view.bounds];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
	
    //Set View Strings
    welcomeString = @"Welcome To Shara.";
    loginString = @"Please Log In To Your Account";
    userString = @"New user?  Click here.";
    
    //Set Welcome Label Attributes
    welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 40.0, 270.0, 50.0)];
    [welcomeLabel setText:welcomeString];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setNumberOfLines:1];
    [welcomeLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [welcomeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [welcomeLabel setFont:[UIFont fontWithName:@"RaveParty Poster" size:24]];
    [self.view addSubview:welcomeLabel];
    
    // Set Login Label Attributes
    loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 80.0, 270.0, 50.0)];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [loginLabel setNumberOfLines:1];
    [loginLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [loginLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    [loginLabel setText:loginString];
    [self.view addSubview:loginLabel];
    
    //Set Username Text Field
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(35.0, 140.0, 250.0, 50.0)];
    usernameField.borderStyle = UITextBorderStyleNone;
    usernameField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    usernameField.placeholder = @"Enter Username";
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.keyboardType = UIKeyboardTypeDefault;
    usernameField.returnKeyType = UIReturnKeyDone;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameField.delegate = self;
    [self.view addSubview:usernameField];
    
    //Set Password Text Field
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(35.0, 204.0, 250.0, 50.0)];
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    passwordField.placeholder = @"Enter Password";
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordField.delegate = self;
    [self.view addSubview:passwordField];
    
    //Four Square Log In Button Attributes
    fourSquareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fourSquareButton setFrame:CGRectMake(25.0, 284.0, 270.0, 50.0)];
    [fourSquareButton setTitle:@"Log in with                " forState:UIControlStateNormal];
    fourSquareButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    fourSquareButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:173.0/255.0 blue:239.0/255.0 alpha:1];
    [fourSquareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fourSquareButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fourSquareButton];
    
    //Facebook Logo Attributes
    fourSquareLogo = [[UIImage alloc] init];
    fourSquareLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(140.0, 15.0, 80.5, 22.0)];
    fourSquareLogo = [UIImage imageNamed:@"foursquare-logo"];
    [fourSquareLogoView setImage:fourSquareLogo];
    [fourSquareButton addSubview:fourSquareLogoView];
    
    // Set Login Label Attributes
    userLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 338.0, 270.0, 50.0)];
    [userLabel setTextAlignment:NSTextAlignmentCenter];
    [userLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [userLabel setNumberOfLines:1];
    [userLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [userLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    [userLabel setText:userString];
    [self.view addSubview:userLabel];
    
    //Setting colors in Welcome Label
    NSMutableAttributedString * userStr = [[NSMutableAttributedString alloc] initWithString:userString];
    [userStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] range:NSMakeRange(0,10)];
    [userStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:140.0/255.0 green:169.0/255.0 blue:165.0/255.0 alpha:1] range:NSMakeRange(10,11)];
    [userLabel setAttributedText:userStr];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newUser:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [userLabel addGestureRecognizer:tapGestureRecognizer];
    [userLabel setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newUser:(id)sender
{
    NewUserViewController * newUserViewController = [[NewUserViewController alloc] init];
    [self presentViewController:newUserViewController animated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
    
	[self processFieldEntries];
}

- (void)processFieldEntries {
	NSString *username = usernameField.text;
	NSString *password = passwordField.text;
	NSString *noUsernameText = @"username";
	NSString *noPasswordText = @"password";
	NSString *errorText = @"No ";
	NSString *errorTextJoin = @" or ";
	NSString *errorTextEnding = @" entered";
	BOOL textError = NO;
    
	if (username.length == 0 || password.length == 0) {
		textError = YES;
        
		if (password.length == 0) {
			[passwordField becomeFirstResponder];
		}
		if (username.length == 0) {
			[usernameField becomeFirstResponder];
		}
	}
    
	if (username.length == 0) {
		textError = YES;
		errorText = [errorText stringByAppendingString:noUsernameText];
	}
    
	if (password.length == 0) {
		textError = YES;
		if (username.length == 0) {
			errorText = [errorText stringByAppendingString:errorTextJoin];
		}
		errorText = [errorText stringByAppendingString:noPasswordText];
	}
    
	if (textError) {
		errorText = [errorText stringByAppendingString:errorTextEnding];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alertView show];
		return;
	}
    
	[PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        
		if (user) {
			[self fourSquareLogin];
		} else {
			UIAlertView *alertView = nil;
            
			if (error == nil) {
				alertView = [[UIAlertView alloc] initWithTitle:@"Couldn’t log in:\nThe username or password were wrong." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			} else {
				alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			}
			[alertView show];
			[usernameField becomeFirstResponder];
		}
	}];
}

//Foursquare OAuth Request To Login User To Shara
- (void)fourSquareLogin
{
    FSOAuthStatusCode statusCode = [FSOAuth authorizeUserUsingClientId:@"QU0M5DFIEL3JRIA0K51YB4OYEOK5P4BECLQMZTJ1SLHFEBNJ"
                                                     callbackURIString:@"shara://www.solitondesignlab.com/shara"
                                                  allowShowingAppStore:YES];
    
    switch (statusCode) {
        case FSOAuthStatusSuccess:
            NSLog(@"Successful login");
            break;
        case FSOAuthStatusErrorInvalidCallback: {
            NSLog(@"Invalid callback URI");
            break;
        }
        case FSOAuthStatusErrorFoursquareNotInstalled: {
            NSLog(@"Foursquare not installed");
            break;
        }
        case FSOAuthStatusErrorInvalidClientID: {
            NSLog(@"Invalid client id");
            break;
        }
        case FSOAuthStatusErrorFoursquareOAuthNotSupported: {
            NSLog(@"Installed FSQ app does not support oauth");
            break;
        }
        default: {
            NSLog(@"Unknown status code returned");
            break;
        }
    }
}

- (NSString *)errorMessageForCode:(FSOAuthErrorCode)errorCode {
    NSString *resultText = nil;
    
    switch (errorCode) {
        case FSOAuthErrorNone: {
            break;
        }
        case FSOAuthErrorInvalidClient: {
            resultText = @"Invalid client error";
            break;
        }
        case FSOAuthErrorInvalidGrant: {
            resultText = @"Invalid grant error";
            break;
        }
        case FSOAuthErrorInvalidRequest: {
            resultText =  @"Invalid request error";
            break;
        }
        case FSOAuthErrorUnauthorizedClient: {
            resultText =  @"Invalid unauthorized client error";
            break;
        }
        case FSOAuthErrorUnsupportedGrantType: {
            resultText =  @"Invalid unsupported grant error";
            break;
        }
        case FSOAuthErrorUnknown:
        default: {
            resultText =  @"Unknown error";
            break;
        }
    }
    
    return resultText;
}

- (void)handleURL:(NSURL *)url {
    
    if ([[url scheme] isEqualToString:@"shara"]) {
        FSOAuthErrorCode errorCode;
        NSString *accessCode = [FSOAuth accessCodeForFSOAuthURL:url error:&errorCode];;
        NSString *resultText = nil;
        
        if (errorCode == FSOAuthErrorNone) {
            resultText = [NSString stringWithFormat:@"%@", accessCode];
            PFUser * user = [PFUser currentUser];
            user[@"fourSquareToken"] = resultText;
            [user saveInBackground];
            self.latestAccessCode = accessCode;
            LoginViewController * myAccessCode = [LoginViewController sharedAccessCode];
            myAccessCode.currentAccessCode = self.latestAccessCode;
            [(SDLAppDelegate*)[[UIApplication sharedApplication] delegate] presentMainViewController];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            resultText = [self errorMessageForCode:errorCode];
        }
        
        NSLog(@"Result: %@", resultText);
    }
}


@end
