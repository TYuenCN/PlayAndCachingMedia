//
//  YSAppDelegate.m
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import "YSAppDelegate.h"
#import "MCMoviePlayerViewController.h"
#import "YSRootViewController.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>
@implementation YSAppDelegate
@synthesize provider;

- (void) provider:(YSCacheAbilityRemoteFileProvider *)provider  isStartCachingUseLocalFileURL:(NSURL *)url localFilePath:(NSString *)path
{
//    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//    [self.window.rootViewController presentMoviePlayerViewControllerAnimated:mpvc];
    
    MCMoviePlayerViewController * mp = [[MCMoviePlayerViewController alloc] initWithContentURL:url];
    mp.moviePlayer.controlStyle =  MPMovieControlStyleFullscreen;
    [mp.moviePlayer setShouldAutoplay:YES];
    [mp.moviePlayer prepareToPlay];
    
    [self.window.rootViewController  presentMoviePlayerViewControllerAnimated:mp];
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@"LocalFileURL: %@", [url description]);
    NSLog(@"LocalFilePath: %@", path);
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>");
}

- (void)videoFinished
{
    self.provider = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[YSRootViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    //视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    self.provider = [[YSCacheAbilityRemoteFileProvider alloc] initWithRemoteURL:[NSURL URLWithString:@"http://adfa.oss-cn-qingdao.aliyuncs.com/60s.mp4"]];
    [provider setDelegate:self];
    [provider prepareProvider];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Obj-1", @"Key-1", @"Obj-2", @"Key-2", nil];
    for (NSString *key in dic) {
        NSLog(@"%@", key);
    }
    
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
