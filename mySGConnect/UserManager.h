//
//  UserManager.h
//  mySGConnect
//
//  Created by Pierre Yao on 04/10/2014.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (UserManager*)sharedInstance;
- (void)createUser:(NSDictionary *)userInfoDictionnary;
@property (nonatomic, strong) NSString *userLastName;
@property (nonatomic, strong) NSString *userFirstName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSNumber *userBalance;
@property (nonatomic, strong) NSString *cashoutDate;
@property (nonatomic, strong) NSNumber *pinCode;




@end
