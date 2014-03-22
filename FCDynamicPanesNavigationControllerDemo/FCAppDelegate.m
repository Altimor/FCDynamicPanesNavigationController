//
//  FCAppDelegate.m
//  FCDynamicPanesNavigationControllerDemo
//
//  Created by Florent Crivello on 3/20/14.
//  Copyright (c) 2014 Indri. All rights reserved.
//

#import "FCAppDelegate.h"
#import "FCDynamicPanesNavigationController.h"

@implementation FCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UIViewController *viewController1 = [UIViewController new];
	viewController1.view.backgroundColor = [UIColor colorWithRed: 0.102 green: 0.737 blue: 0.612 alpha: 1];
	
	UIViewController *viewController2 = [UIViewController new];
	viewController2.view.backgroundColor = [UIColor colorWithRed: 0.204 green: 0.286 blue: 0.369 alpha: 1];
	
	UIViewController *viewController3 = [UIViewController new];
	viewController3.view.backgroundColor = [UIColor colorWithRed: 0.945 green: 0.769 blue: 0.0588 alpha: 1];

	FCDynamicPanesNavigationController *dynamicPanes = [[FCDynamicPanesNavigationController alloc] initWithViewControllers:@[viewController1, viewController2, viewController3]];
	self.window.rootViewController = dynamicPanes;
	
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
