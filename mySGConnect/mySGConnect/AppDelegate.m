//
//  AppDelegate.m
//  mySGConnect
//
//  Created by Christopher Saez on 04/10/14.
//  Copyright (c) 2014 teamSGAdviser. All rights reserved.
//

#import "AppDelegate.h"
#import "RetraitViewController.h"
#import "AccueilViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion1;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion2;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"];
	self.beaconRegion1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
																 major:0
																 minor:0
															identifier:@"com.mysgconnnect"];
	self.beaconRegion2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
																 major:0
																 minor:1
															identifier:@"com.mysgconnnect"];
	self.beaconRegion1.notifyEntryStateOnDisplay  = TRUE;
	self.beaconRegion1.notifyOnEntry = TRUE;
	self.beaconRegion2.notifyEntryStateOnDisplay  = TRUE;
	self.beaconRegion2.notifyOnEntry = TRUE;
	[self.locationManager startMonitoringForRegion:self.beaconRegion1];
	[self.locationManager startMonitoringForRegion:self.beaconRegion2];
	
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	AccueilViewController *vc = (AccueilViewController*) [storyboard instantiateViewControllerWithIdentifier:@"AccueilViewController"];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
	[self.window makeKeyAndVisible];
	[self.window.rootViewController presentViewController:self.navigationController animated:NO completion:^{
		
	}];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
	
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
	[self.locationManager startRangingBeaconsInRegion:region];
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	RetraitViewController *rvc = [storyboard instantiateViewControllerWithIdentifier:@"RetraitViewController"];
	[self.navigationController pushViewController:rvc animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
	[self.locationManager stopRangingBeaconsInRegion:region];
	
}

- (void) application:(UIApplication *) application didReceiveLocalNotification:(UILocalNotification *) notification
{
	
	
}


@end
