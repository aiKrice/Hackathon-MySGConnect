//
//  RetraitViewController.m
//  mySGConnect
//
//  Created by Christopher Saez on 04/10/14.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import "RetraitViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "ValidationRetraitViewController.h"
#import <AFNetworking.h>
#import "UserManager.h"
#import <LocalAuthentication/LocalAuthentication.h>


@interface RetraitViewController ()
{
  BOOL firstTime;
  BOOL errorAuthen;
}

@property (weak, nonatomic) IBOutlet UITextField *moneyInputTF;
@property (weak, nonatomic) IBOutlet UIImageView *signalWeak;
@property (weak, nonatomic) IBOutlet UIImageView *signalNormal;
@property (weak, nonatomic) IBOutlet UIImageView *signalStrong;
@property (weak, nonatomic) IBOutlet UIImageView *clavier;
@property (assign, nonatomic) int pinSize;
@property (weak, nonatomic) IBOutlet UILabel *actualBalance;

-(void) refreshImageBeacon:(NSTimer *)timer;
- (void) onDidTap:(UITapGestureRecognizer*) sender;
@end

@implementation RetraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  firstTime = false;
  errorAuthen = false;
	self.moneyInputTF.delegate = self;
  [self.moneyInputTF addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
  [self.actualBalance setText:[NSString stringWithFormat:@"%@",[UserManager sharedInstance].userBalance]];
	
	[NSTimer scheduledTimerWithTimeInterval:1
									 target:self
								   selector:@selector(refreshImageBeacon:)
								   userInfo:nil
									repeats:YES];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDidTap:)];
	tap.delegate = self;
	self.clavier.userInteractionEnabled = YES;
	[self.clavier addGestureRecognizer:tap];
	self.pinSize = 0;
}

- (void) onDidTap:(UITapGestureRecognizer*) sender{
	self.pinSize++;
	if (self.pinSize > 3){
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		ValidationRetraitViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ValidationRetraitViewController"];
		[self dismissViewControllerAnimated:YES completion:^{
			[self RetraitRequete];
			AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
			[appdelegate.navigationController presentViewController:vc animated:YES completion:nil];
			
		}];
	}
}

-(void) refreshImageBeacon: (NSTimer *)timer{
	AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	CLProximity proximity = appdelegate.proximity;
	if (proximity == CLProximityImmediate){
    [self promptTouchId];
		
		self.signalStrong.hidden = NO;
	} else {
		self.signalStrong.hidden = YES;
		
		if (proximity == CLProximityNear){
			[self displaySecureKeyboard];
			self.signalNormal.hidden = NO;
		} else {
			[self removeSecureKeyboard];
			self.signalNormal.hidden = YES;
		}
		
	}
	
}

- (void)promptTouchId
{
  if (!firstTime)
  {
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Voulez-vous vous authentifier par empreinte digitale.";
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
      
      [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:myLocalizedReasonString
                          reply:^(BOOL succes, NSError *error) {
                            
                            if (succes) {
                              
                              NSLog(@"User is authenticated successfully");
                              [self RetraitRequete];
                            } else {
                              
                              switch (error.code) {
                                case LAErrorAuthenticationFailed:
                                  NSLog(@"Authentication Failed");
                                  break;
                                  
                                case LAErrorUserCancel:
                                  NSLog(@"User pressed Cancel button");
                                  errorAuthen = true;
                                  break;
                                  
                                case LAErrorUserFallback:
                                  NSLog(@"User pressed \"Enter Password\"");
                                  errorAuthen = true;
                                  break;
                                  
                                default:
                                  NSLog(@"Touch ID is not configured");
                                  errorAuthen = true;
                                  break;
                              }
                              
                              NSLog(@"Authentication Fails");
                              errorAuthen = true;
                              
                            }
                          }];
    } else {
      
      NSLog(@"Can not evaluate Touch ID");
      
    }
    
    firstTime = true;

  }
  if (errorAuthen)
  {
    [self displaySecureKeyboard];
  }
}

- (void)checkTextField:(id)sender
{
  int displayBalance = (uint32_t)[[UserManager sharedInstance].userBalance integerValue] - (uint32_t)[self.moneyInputTF.text integerValue];
  [self.actualBalance setText:[NSString stringWithFormat:@"%d", displayBalance]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displaySecureKeyboard{
	self.clavier.hidden = NO;
}

- (void)RetraitRequete
{
  NSString *baseURL = @"http://10.18.197.199:8888/ibeacon/user.php?";
  AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
  
  int newBalance = [self calculateNewBalanceWith:[UserManager sharedInstance].userBalance andActualMoney:self.moneyInputTF.text];
  NSNumber *balanceTosend = [[NSNumber alloc] initWithInt:newBalance];
  [requestManager GET:baseURL parameters:@{@"method":@"retrait", @"email":@"saez@sg.com", @"balance":balanceTosend} success:^(AFHTTPRequestOperation *operation, id responseObject) {
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

- (int)calculateNewBalanceWith:(NSNumber *)userBalance andActualMoney:(NSString *)money
{
  int newMoney = (uint32_t)[money integerValue];
  int newBalance = (uint32_t)[userBalance integerValue] - newMoney;
  return newBalance;
}

-(void) removeSecureKeyboard{
	self.clavier.hidden = YES;
	
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	return true;
}

@end
