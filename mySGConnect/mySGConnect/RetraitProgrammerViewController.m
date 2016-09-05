//
//  RetraitProgrammerViewController.m
//  mySGConnect
//
//  Created by Pierre Yao on 05/10/2014.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import "RetraitProgrammerViewController.h"
#import "UserManager.h"
#define rgb(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

@interface RetraitProgrammerViewController ()<UIAlertViewDelegate>

@end

@implementation RetraitProgrammerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.moneyInputTF.delegate = self;
  [self.moneyInputTF addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
  [self.actualBalance setText:[NSString stringWithFormat:@"%@ €",[UserManager sharedInstance].userBalance]];
    // Do any additional setup after loading the view.
	
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(didClose)];
	self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.barTintColor = rgb(229, 74, 77);
}


-(void) didClose{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkTextField:(id)sender
{
  int displayBalance = (uint32_t)[[UserManager sharedInstance].userBalance integerValue] - (uint32_t)[self.moneyInputTF.text integerValue];
  [self.actualBalance setText:[NSString stringWithFormat:@"%d €", displayBalance]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  UIAlertView *programmer = [[UIAlertView alloc] initWithTitle:@"Retrait Enregistrer" message:[NSString stringWithFormat:@"Votre retrait de %@ euros à bien été programmé. Vous pouvez vous rendre à un distributeur. Le retrait sera valable pendant 30 minutes.", self.moneyInputTF.text] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
  [programmer show];
  [UserManager sharedInstance].programRetraituserBalance = [NSNumber numberWithInteger:[self.moneyInputTF.text integerValue]];

  return true;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[self dismissViewControllerAnimated:YES completion:nil];
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
