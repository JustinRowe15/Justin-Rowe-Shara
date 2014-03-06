//
//  Constants.m
//  Shara
//
//  Created by Justin Rowe on 2/6/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#pragma mark - PFUser Class
//Class Key
NSString * const kNZLUserClassKey   = @"user";

//Field Key
NSString * const kNZLUserPhotoKey   = @"userPhoto";

#pragma mark - PFObject Solutions Class
//Class Key
NSString * const kNZLSolutionsClassKey   = @"solutions";

//Field Keys
NSString * const kNZLSolutionsNameKey        = @"solutionName";
NSString * const kNZLSolutionsLocationKey    = @"solutionLocation";
NSString * const kNZLSolutionsQuantityKey    = @"solutionQuantity";
NSString * const kNZLSolutionsAdvisorKey     = @"solutionAdvisor";

#pragma mark - PFObject Personnel Class
//Class Key
NSString * const kNZLPersonnelClassKey       = @"personnel";

//Field Keys
NSString * const kNZLPersonnelNameKey        = @"personnelName";
NSString * const kNZLPersonnelLocationKey    = @"personnelLocation";
NSString * const kNZLPersonnelCellNumberKey  = @"personnelCell";
NSString * const kNZLPersonnelEmailKey       = @"personnelEmail";

#pragma mark - PFObject Vendor Class
//Class Key
NSString * const kNZLVendorsClassKey     = @"vendor";

//Field Keys
NSString * const kNZLVendorNameKey                       = @"vendorName";
NSString * const kNZLVendorAddressStreetKey              = @"vendorStreet";
NSString * const kNZLVendorAddressCityKey                = @"vendorCity";
NSString * const kNZLVendorAddressStateKey               = @"vendorState";
NSString * const kNZLVendorAddressZipKey                 = @"vendorZip";
NSString * const kNZLVendorPointOfContactNameKey         = @"vendorPointOfContactName";
NSString * const kNZLVendorPointOfContactCellNumberKey   = @"vendorPointOfContactCellNumber";
NSString * const kNZLVendorPointOfContactEmailKey        = @"vendorPointOfContactEmail";

#pragma mark - PFObject Photo Class
//Class Key
NSString * const kNZLPhotoClassKey   = @"userPhoto";

//Field Keys
NSString * const kNZLPhotoImageFileKey  = @"imageFile";

@end
