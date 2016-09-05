//
//  ViewController.m
//  mySGConnect
//
//  Created by Christopher Saez on 04/10/14.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import "AccueilViewController.h"
#import "UserManager.h"
#import "RetraitProgrammerViewController.h"

@implementation AccueilViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[UserManager sharedInstance].retraitProgrammer = @"Non";
	self.navigationController.navigationBar.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)programRetrait:(id)sender
{
	[UserManager sharedInstance].retraitProgrammer = @"Oui";
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	RetraitProgrammerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RetraitProgrammerViewController"];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self.navigationController presentViewController:nav animated:YES completion:nil];
}

@end
