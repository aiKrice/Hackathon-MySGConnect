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

static UserManager *_sharedInstance;

@end
