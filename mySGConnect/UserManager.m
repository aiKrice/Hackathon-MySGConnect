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
  self.userLastName = [userInfoDictionnary objectForKey:@"lastname"];
  self.userFirstName = [userInfoDictionnary objectForKey:@"firstname"];
  self.userEmail = [userInfoDictionnary objectForKey:@"email"];
  self.userId = [userInfoDictionnary objectForKey:@"idUSER"];
  self.userBalance = [NSNumber numberWithInt:[[userInfoDictionnary objectForKey:@"balance"] intValue]];
  self.cashoutDate = [userInfoDictionnary objectForKey:@"datederetrait"];
  self.pinCode = [NSNumber numberWithInt:[[userInfoDictionnary objectForKey:@"PINCODE"] intValue]];
}

@end
