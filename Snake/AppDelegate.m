//
//  AppDelegate.m
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import "AppDelegate.h"
#import "ObjectConfigurator.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[ObjectConfigurator sharedInstanceWithScreenSize:self.window.frame.size] gameViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
