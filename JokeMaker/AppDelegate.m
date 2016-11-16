//
//  AppDelegate.m
//  JokeMaker
//
//  Created by Dou, Eddie on 11/17/16.
//  Copyright © 2016 GuDuTou. All rights reserved.
//

#import "AppDelegate.h"
#import "AppUtils.h"
#import "HomeViewController.h"
#import "IQKeyboardManager.h"

@implementation AppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = true;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(228/255.0) green:(224 / 255.0) blue:(221 / 255.0) alpha:1]];

    self.navigationController = [[MSNavigationSwipeController alloc] initWithRootViewController:[[HomeViewController alloc] init]];

    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
