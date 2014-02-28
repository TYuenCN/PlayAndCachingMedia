//
//  YSCacheAbilityRemoteFileProvider.h
//  PlayAndCachingMedia
//
//  1、用远程资源的地址初始化本类，将创建ASIHTTPRequest对象，开始断点续传资源，并缓存到指定目录；
//
//  2、同时，在ASIHTTPRequest开始缓存前，即，在接到请求资源的头时，先获取资源的完整原始大小，作用：(1)用来判断是否是完全缓冲完的资源。
//  (2)用来在提供HTTPServer服务，提供本缓存着的资源使用的时候，要返回头且包含资源的完整大小（此时资源可能还正在缓存，缓存的文件大小
//  跟资源的实际大小不一样，这时通过本地HTTPServer请求这个资源，获取的HTTP响应头只是缓存的大小，例如提供给MoviePlayer使用，将可能加载
//  不全视频。
//
//  3、判断资源缓存的状态，开启HTTPServer服务，拼接并返回URL给代理。
//
//  Warnning:
//          Extend & Modified HTTPServer, So we have chance to modify the content length to real-remote-file-length that in response header.
//          ASIHTTPRequest：没有继承，而进行了硬性修改，目的是在使用缓存的时候，下载完成不让其删除掉缓存文件。
//                                      具体请看本项目的ASIHTTPRequest
//
//  E.X.:
//
//          - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//          {
//              //视频播放结束通知
//              [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//
//              self.provider = [[YSCacheAbilityRemoteFileProvider alloc] initWithRemoteURL:[NSURL URLWithString:@"http://xxx.mp4"]];
//              [provider setDelegate:self];
//              [provider prepareProvider];
//          }
//          - (void) provider:(YSCacheAbilityRemoteFileProvider *)provider  isStartCachingToLocalFileURL:(NSURL *)url
//          {
//              MCMoviePlayerViewController * mp = [[MCMoviePlayerViewController alloc] initWithContentURL:url];
//              mp.moviePlayer.controlStyle =  MPMovieControlStyleFullscreen;
//              [mp.moviePlayer setShouldAutoplay:YES];
//              [mp.moviePlayer prepareToPlay];
//
//              [self.window.rootViewController  presentMoviePlayerViewControllerAnimated:mp];
//          }
//          - (void)videoFinished
//          {
//              self.provider = nil;
//          }
//
//  Created by TsengYuen on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//
#ifndef YSCacheAbilityRemoteFileProvider_H
#define YSCacheAbilityRemoteFileProvider_H

#import <Foundation/Foundation.h>

#pragma mark - Macro Definition
//
//  默认的Remote资源缓存的基准路径：
//  /Library/Cache/YSMedia
//
#define DEFAULT_CACHE_DIRECTORY_PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/YSMedia/"]
//
//  归档文件中字典的Key；保存资源真实大小信息的字典；
//
#define CACHE_INFO_ARCHIVE_KEY @"cache_info.archiver"
//
//  归档文件名字；
//
#define CACHE_INFO_ARCHIVE_FILE_NAME @"cache_info.archiver"
//
//  归档文件全路径；
//
#define CACHE_INFO_ARCHIVE_FILE_PATH [DEFAULT_CACHE_DIRECTORY_PATH stringByAppendingPathComponent:CACHE_INFO_ARCHIVE_FILE_NAME]

@class YSCacheAbilityRemoteFileProvider;

#pragma mark - YSCacheAbilityRemoteFileProviderDelegate
//
//  当开始缓存，并能提供本地缓存的LocalServer的URL时，将调用代理方法；
//  进入本方法后，意味着已经开始缓存，并可以开始使用正在缓存或已经缓存完的数据；（播放视频）
//
@protocol YSCacheAbilityRemoteFileProviderDelegate
- (void) provider:(YSCacheAbilityRemoteFileProvider *)provider  isStartCachingToLocalFileURL:(NSURL *)url;
@end

#pragma mark - YSCacheAbilityRemoteFileProvider
@interface YSCacheAbilityRemoteFileProvider : NSObject
@property (nonatomic, assign) id<YSCacheAbilityRemoteFileProviderDelegate> delegate;

//
//  Used the remote file's URL init this object;
//
//  使用远程文件资源的地址，初始化此对象；
//
- (id)initWithRemoteURL:(NSURL *)remoteURL;

//
//  Invoke This Massage, That Will Be Ready To Use。
//
//  此为入口方法：当调用后，开始检查；
//      如是第一次调用的URL，将开始缓存并提供本地服务；
//      如是已经缓存并没有缓存完成，则继续缓存，并提供本地服务；
//      如是已经完全缓存过的，将直接返回本地文件的FileURL；
//
- (void)prepareProvider;
@end

#endif