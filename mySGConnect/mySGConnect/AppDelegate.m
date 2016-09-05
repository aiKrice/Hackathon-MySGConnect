
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
#import <AFNetworking/AFNetworking.h>
#import "UserManager.h"
#import "OfferViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion1;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion2;
@property (strong, nonatomic) NSUUID *uuid;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
	
	[self getUserInformation];
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	
	[self.locationManager requestAlwaysAuthorization];
	self.uuid = [[NSUUID alloc] initWithUUIDString:@"CB77A7EF-E3F6-4375-BAED-A107205DAE7F"];
	self.beaconRegion1 = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid
																 major:0
																 minor:0
															identifier:@"com.mysgconnnect"];
	self.beaconRegion2 = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid
																 major:1
																 minor:1
															identifier:@"com.mysgconnnect"];
	return YES;
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
	[self sendDidEnterRequest:region];
	[self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	RetraitViewController *rvc = [storyboard instantiateViewControllerWithIdentifier:@"RetraitViewController"];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rvc];
	[self.window.rootViewController presentViewController:nav animated:YES completion:nil];
	[self sendLocalNotification:[NSString stringWithFormat:@"Bonjour et bienvenue à votre agence Société générale Mr %@",[UserManager sharedInstance].userLastName] withData:nil withRegion:(CLBeaconRegion*)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
	[self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
	
	/*CLBeaconRegion *bregion = (CLBeaconRegion*) region;
	 NSString *removeKeyOnDictionnary = [NSString stringWithFormat:@"%@-%@-%@", bregion.proximityUUID.UUIDString, bregion.major, bregion.minor];
	 NSString *passageID = [self.passageDictionnary objectForKey:[NSString stringWithFormat:@"%@-%@-%@", bregion.proximityUUID.UUIDString, bregion.major, bregion.minor]];
	 [self.passageDictionnary removeObjectForKey:removeKeyOnDictionnary];
	 [self didExitRegionWithPassage:passageID];*/
	
	[self sendLocalNotification: [NSString stringWithFormat:@"Merci d'être venu et à bientot Mr %@.",[UserManager sharedInstance].userLastName] withData:@"exit" withRegion:(CLBeaconRegion*)region];
	
}

-(void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
	CLBeacon *beacon = [beacons firstObject];
	
	self.proximity = beacon.proximity;
}

- (void)sendDidEnterRequest:(CLRegion*) region {
	
	/*NSString *baseURL = @"http://10.18.197.199:8888/ibeacon/user.php?";
	 NSString *email = @"saez@sg.com";
	 NSString *beaconIDAndMajorMinor = [NSString stringWithFormat:@"%@-%@-%@", ((CLBeaconRegion*)region).proximityUUID.UUIDString, ((CLBeaconRegion*)region).major, ((CLBeaconRegion*)region).minor];
	 AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
	 [requestManager GET:baseURL parameters:@{@"method":@"checkOnDidEnter", @"email":email, @"beaconID":beaconIDAndMajorMinor} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSString *passageID = [responseObject objectForKey:@"passageID"];
		[self.passageDictionnary setValue:passageID forKey:beaconIDAndMajorMinor];
		
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	 }];*/
}

- (void)getUserInformation{
	[[UserManager sharedInstance] createUser:nil];
	[self.locationManager startMonitoringForRegion:self.beaconRegion1];
	[self.locationManager startMonitoringForRegion:self.beaconRegion2];
	/*NSString *baseURL = @"http://10.18.197.199:8888/ibeacon/user.php?method=login";
	 NSString *email = @"saez@sg.com";
	 NSString *finalUrl = [NSString stringWithFormat:@"%@&email=%@", baseURL, email];
	 AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
	 [requestManager GET:finalUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[[UserManager sharedInstance] createUser:responseObject];
		
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	 }];*/
}

- (void)didExitRegionWithPassage:(NSString*)passageID
{
	/*	NSString *baseURL = @"http://10.18.197.199:8888/ibeacon/user.php?";
	 AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
	 [requestManager GET:baseURL parameters:@{@"method":@"onDidExit", @"passageID":passageID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	 }];*/
}

- (void) application:(UIApplication *) application didReceiveLocalNotification:(UILocalNotification *) notification {
	application.applicationIconBadgeNumber = 0;
	if (notification.userInfo != nil && [[notification.userInfo objectForKey:@"action"] isEqualToString:@"exit"]){
		[self.navigationController dismissViewControllerAnimated:YES completion:^{
			NSString *url = nil;
			if ([[notification.userInfo objectForKey:@"region"] isEqualToString:@"CB77A7EF-E3F6-4375-BAED-A107205DAE7F-1-1"]){
				url = @"http://www.auchan.fr";
			} else {
				url = @"http://www.galerieslafayette.com/";
			}
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			OfferViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OfferViewController"];
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
			vc.url = url;
			[self.window.rootViewController presentViewController:nav animated:YES completion:nil];
		}];
		
	}
}

-(void) sendLocalNotification: (NSString*) message withData: (NSString*) data withRegion: (CLBeaconRegion*) region{
	UILocalNotification *notif = [[UILocalNotification alloc] init];
	notif.alertBody = message;
	if (data != nil){
		notif.userInfo = @{@"action": @"exit", @"region": [NSString stringWithFormat:@"%@-%@-%@", ((CLBeaconRegion*)region).proximityUUID.UUIDString, ((CLBeaconRegion*)region).major, ((CLBeaconRegion*)region).minor]};
	}
	notif.soundName = UILocalNotificationDefaultSoundName;
	notif.applicationIconBadgeNumber += 1;
	[[UIApplication sharedApplication] presentLocalNotificationNow:notif];
}

@end
