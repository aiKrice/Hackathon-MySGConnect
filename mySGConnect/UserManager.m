//
//  UserManager.m
//  mySGConnect
//
//  Created by Pierre Yao on 04/10/2014.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()
{
  
}


@end

@implementation UserManager

+ (UserManager*)sharedInstance
{
  // 1
  static UserManager *_sharedInstance = nil;
  
  // 2
  static dispatch_once_t oncePredicate;
  
  // 3
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[UserManager alloc] init];
  });
  return _sharedInstance;
}

- (void)createUser:(NSDictionary *)userInfoDictionnary
{
  self.userLastName = @"Saez";
  self.userFirstName = @"Christopher";
  self.userEmail = @"christopher.saez@yopmail.com";
  self.userId = @"123456";
  self.userBalance = [NSNumber numberWithInt:100];
  self.cashoutDate = @"20 juillet 2014";
  self.pinCode = [NSNumber numberWithInt:1234];
}

@end
