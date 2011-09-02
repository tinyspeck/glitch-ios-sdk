/*-
 *  Glitch iOS SDK Sample App
 *  
 *  Copyright 2011 Tiny Speck, Inc.
 *  Created by Brady Archambo.
 *
 *  http://www.glitch.com
 *  http://www.tinyspeck.com
 */

#import "SampleAppDelegate.h"

#import "SampleViewController.h"

@implementation SampleAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[_viewController glitch] handleOpenURL:url];
    
    return YES;
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
