//
//  RetraitProgrammerViewController.h
//  mySGConnect
//
//  Created by Pierre Yao on 05/10/2014.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetraitProgrammerViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *actualBalance;
@property (weak, nonatomic) IBOutlet UITextField *moneyInputTF;

@end
