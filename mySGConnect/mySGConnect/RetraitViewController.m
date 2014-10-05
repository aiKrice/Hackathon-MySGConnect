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


@interface RetraitViewController ()

@property (weak, nonatomic) IBOutlet UITextField *moneyInputTF;
@property (weak, nonatomic) IBOutlet UIImageView *signalWeak;
@property (weak, nonatomic) IBOutlet UIImageView *signalNormal;
@property (weak, nonatomic) IBOutlet UIImageView *signalStrong;
@property (weak, nonatomic) IBOutlet UIImageView *clavier;
@property (assign, nonatomic) int pinSize;

-(void) refreshLabel:(NSTimer *)timer;
- (void) onDidTap:(UITapGestureRecognizer*) sender;
@end

@implementation RetraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.moneyInputTF.delegate = self;
	
	
	[NSTimer scheduledTimerWithTimeInterval:1
									 target:self
								   selector:@selector(refreshLabel:)
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
			AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
			[appdelegate.navigationController presentViewController:vc animated:YES completion:nil];
			
		}];
	}
}

-(void) refreshLabel: (NSTimer *)timer{
	AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	CLProximity proximity = appdelegate.proximity;
	if (proximity == CLProximityImmediate){
		[self displaySecureKeyboard];
		self.signalStrong.hidden = NO;
	} else {
		self.signalStrong.hidden = YES;
		[self removeSecureKeyboard];
		if (proximity == CLProximityNear){
			self.signalNormal.hidden = NO;
		} else {
			self.signalNormal.hidden = YES;
		}
		
	}
	
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displaySecureKeyboard{
	self.clavier.hidden = NO;
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
