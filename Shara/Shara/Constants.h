//
//  Constants.h
//  Shara
//
//  Created by Justin Rowe on 2/6/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

static double const kNZLFeetToMeters = 0.3048;
static double const kNZLFeetToMiles = 5280.0;
static double const kNZLWallPinMaximumSearchDistance = 100.0;
static double const kNZLMetersInAKilometer = 1000.0;
static NSUInteger const kNZLWallPinsSearch = 20;
static NSUInteger const kNZLCheckInPostMaximumCharacterCount = 140;

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#pragma mark - PFUser Class
//Class Key
extern NSString * const kNZLUserClassKey;

//Field Keys
extern NSString * const kNZLUserPhotoKey;

#pragma mark - PFObject Solutions Class
//Class Key
extern NSString * const kNZLSolutionsClassKey;

//Field Keys
extern NSString * const kNZLSolutionsNameKey;
extern NSString * const kNZLSolutionsLocationKey;
extern NSString * const kNZLSolutionsQuantityKey;
extern NSString * const kNZLSolutionsAdvisorKey;

#pragma mark - PFObject Personnel Class
//Class Key
extern NSString * const kNZLPersonnelClassKey;

//Field Keys
extern NSString * const kNZLPersonnelNameKey;
extern NSString * const kNZLPersonnelLocationKey;
extern NSString * const kNZLPersonnelCellNumberKey;
extern NSString * const kNZLPersonnelEmailKey;

#pragma mark - PFObject Vendor Class
//Class Key
extern NSString * const kNZLVendorsClassKey;

//Field Keys
extern NSString * const kNZLVendorNameKey;
extern NSString * const kNZLVendorAddressStreetKey;
extern NSString * const kNZLVendorAddressCityKey;
extern NSString * const kNZLVendorAddressStateKey;
extern NSString * const kNZLVendorAddressZipKey;
extern NSString * const kNZLVendorPointOfContactNameKey;
extern NSString * const kNZLVendorPointOfContactCellNumberKey;
extern NSString * const kNZLVendorPointOfContactEmailKey;

#pragma mark - PFObject Photo Class
//Class Key
extern NSString * const kNZLPhotoClassKey;

//Field Keys
extern NSString * const kNZLPhotoImageFileKey;

@end
