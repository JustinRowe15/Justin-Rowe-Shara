//
//  GetUserData.h
//  Shara
//
//  Created by Justin Rowe on 2/16/14.
//  Copyright (c) 2014 Justin Rowe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetUserDataDelegate <NSObject>

- (void)setProfileView:(NSDictionary *)dictionary;

@end

@interface GetUserData : NSObject

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *tokenCode;
@property (nonatomic, strong) NSDictionary *userDictionary;

- (void)getUserInfo;
- (void)parseJSONData:(NSString *)urlString;

@property (nonatomic, weak)id<GetUserDataDelegate>delegate;

@end
