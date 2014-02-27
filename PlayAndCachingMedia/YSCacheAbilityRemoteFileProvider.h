//
//  YSCacheAbilityRemoteFileProvider.h
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//
#ifndef YSCacheAbilityRemoteFileProvider_H
#define YSCacheAbilityRemoteFileProvider_H

#import <Foundation/Foundation.h>

#define DEFAULT_CACHE_DIRECTORY_PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/YSMedia/"]
#define CACHE_INFO_ARCHIVE_KEY @"cache_info.archiver"
#define CACHE_INFO_ARCHIVE_FILE_NAME @"cache_info.archiver"
#define CACHE_INFO_ARCHIVE_FILE_PATH [DEFAULT_CACHE_DIRECTORY_PATH stringByAppendingPathComponent:CACHE_INFO_ARCHIVE_FILE_NAME]
@class YSCacheAbilityRemoteFileProvider;

#pragma mark - YSCacheAbilityRemoteFileProviderDelegate
@protocol YSCacheAbilityRemoteFileProviderDelegate
- (void) provider:(YSCacheAbilityRemoteFileProvider *)provider  isStartCachingToLocalFileURL:(NSURL *)url;
@end

#pragma mark - YSCacheAbilityRemoteFileProvider
@interface YSCacheAbilityRemoteFileProvider : NSObject
@property (nonatomic, assign) id<YSCacheAbilityRemoteFileProviderDelegate> delegate;

//
//  Cache File will save to this Directory:
//      If not set,Default is MacroDefinition "DEFAULT_CACHE_DIRECTORY_PATH"
//
//  缓存保存的路径：
//      如果没有指定，将使用默认路径，即宏定义“DEFAULT_CACHE_DIRECTORY_PATH”
//
//@property (nonatomic, strong) NSString *cacheDirectoryPath;

//
//  Used the remote file's URL init this object;
//
//  使用远程文件资源的地址，初始化此对象；
//
- (id)initWithRemoteURL:(NSURL *)remoteURL;

//
//  Invoke This Massage, That Will Be Ready To Use
//
- (void)prepareProvider;
@end

#endif