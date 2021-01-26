//
//  AppDelegate.m
//  TTLinkLabel
//
//  Created by hubin on 08/01/2021.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
