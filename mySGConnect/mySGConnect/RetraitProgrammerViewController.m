//
//  RetraitProgrammerViewController.m
//  mySGConnect
//
//  Created by Pierre Yao on 05/10/2014.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import "RetraitProgrammerViewController.h"
#import "UserManager.h"

@interface RetraitProgrammerViewController ()

@end

@implementation RetraitProgrammerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.moneyInputTF.delegate = self;
  [self.moneyInputTF addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
  [self.actualBalance setText:[NSString stringWithFormat:@"%@",[UserManager sharedInstance].userBalance]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkTextField:(id)sender
{
  int displayBalance = (uint32_t)[[UserManager sharedInstance].userBalance integerValue] - (uint32_t)[self.moneyInputTF.text integerValue];
  [self.actualBalance setText:[NSString stringWithFormat:@"%d", displayBalance]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  UIAlertView *programmer = [[UIAlertView alloc] initWithTitle:@"Retrait Enregistrer" message:[NSString stringWithFormat:@"Votre retrait de %@ euros à bien été programmé. Vous pouvez vous rendre à un distributeur. Le retrait sera valable pendant 30 minutes.", self.moneyInputTF.text] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
  [programmer show];
  [UserManager sharedInstance].programRetraituserBalance = [NSNumber numberWithInt:(uint32_t)[self.moneyInputTF.text integerValue]];
  [self dismissViewControllerAnimated:YES completion:nil];

  return true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
