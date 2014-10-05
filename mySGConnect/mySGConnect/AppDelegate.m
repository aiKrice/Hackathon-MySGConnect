
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
#import <AFNetworking.h>
#import "UserManager.h"

@interface AppDelegate ()


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion1;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion2;
@property (strong, nonatomic) NSUUID *uuid;
@property (strong, nonatomic) NSMutableDictionary *passageDictionnary;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
  if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
  }
  
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	
	if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
		[self.locationManager performSelector:@selector(requestAlwaysAuthorization) withObject:nil ];
	}
	
	self.uuid = [[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"];
	NSUUID* uuid2 = [[NSUUID alloc] initWithUUIDString:@"11111111-1111-1111-1111-111111111111"];
	self.beaconRegion1 = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid
																 major:0
																 minor:1
															identifier:@"com.mysgconnnect"];
	self.beaconRegion2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid2
																 major:1
																 minor:1
															identifier:@"com.mysgconnnect"];
	self.beaconRegion1.notifyEntryStateOnDisplay  = TRUE;
	self.beaconRegion1.notifyOnEntry = TRUE;
	self.beaconRegion2.notifyEntryStateOnDisplay  = TRUE;
	self.beaconRegion2.notifyOnEntry = TRUE;
	self.passageDictionnary = [[NSMutableDictionary alloc] init];
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
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	RetraitViewController *rvc = [storyboard instantiateViewControllerWithIdentifier:@"RetraitViewController"];
	switch (state) {
		case CLRegionStateInside:
			[self getUserInformation];
			[self sendDidEnterRequest:region];
			[self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
			
			[self.navigationController presentViewController:rvc animated:YES completion:nil];
			[self sendLocalNotification:@"Bonjour et bienvenue à la societe generale"];
			
			break;
			
		default:
			break;
	}
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
	
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
	[self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	
	CLBeaconRegion *bregion = (CLBeaconRegion*) region;
	NSString *removeKeyOnDictionnary = [NSString stringWithFormat:@"%@-%@-%@", bregion.proximityUUID.UUIDString, bregion.major, bregion.minor];
	NSString *passageID = [self.passageDictionnary objectForKey:[NSString stringWithFormat:@"%@-%@-%@", bregion.proximityUUID.UUIDString, bregion.major, bregion.minor]];
	[self.passageDictionnary removeObjectForKey:removeKeyOnDictionnary];
	[self didExitRegionWithPassage:passageID];
	[self sendLocalNotification:@"Merci d'etre venu et à bientot"];
	
}

-(void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
  CLBeacon *beacon = [beacons firstObject];
  
  self.proximity = beacon.proximity;
}

- (void)sendDidEnterRequest:(CLRegion*) region {
	
	NSString *baseURL = @"http://10.18.197.199:8888/ibeacon/user.php?";
	NSString *email = @"saez@sg.com";
	NSString *beaconIDAndMajorMinor = [NSString stringWithFormat:@"%@-%@-%@", ((CLBeaconRegion*)region).proximityUUID.UUIDString, ((CLBeaconRegion*)region).major, ((CLBeaconRegion*)region).minor];
	AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
	[requestManager GET:baseURL parameters:@{@"method":@"checkOnDidEnter", @"email":email, @"beaconID":beaconIDAndMajorMinor} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSString *passageID = [responseObject objectForKey:@"passageID"];
		[self.passageDictionnary setValue:passageID forKey:beaconIDAndMajorMinor];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)getUserInformation{
	
	NSString *baseURL = @"http://10.18.197.199:8888/ibeacon/user.php?method=login";
	NSString *email = @"saez@sg.com";
	NSString *finalUrl = [NSString stringWithFormat:@"%@&email=%@", baseURL, email];
	AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
	[requestManager GET:finalUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[[UserManager sharedInstance] createUser:responseObject];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}



- (void)didExitRegionWithPassage:(NSString*)passageID
{
	NSString *baseURL = @"http://10.18.197.199:8888/ibeacon/user.php?";
	AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
	[requestManager GET:baseURL parameters:@{@"method":@"onDidExit", @"passageID":passageID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void) application:(UIApplication *) application didReceiveLocalNotification:(UILocalNotification *) notification
{
  notification.applicationIconBadgeNumber = 0;
}

-(void) sendLocalNotification: (NSString*) message{
	UILocalNotification *notif = [[UILocalNotification alloc] init];
	notif.alertBody = message;
	notif.soundName = UILocalNotificationDefaultSoundName;
	notif.applicationIconBadgeNumber += 1;
	[[UIApplication sharedApplication] presentLocalNotificationNow:notif];
}

@end
