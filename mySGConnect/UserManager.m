//
//  UserManager.m
//  mySGConnect
//
//  Created by Pierre Yao on 04/10/2014.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import "UserManager.h"

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

@end
