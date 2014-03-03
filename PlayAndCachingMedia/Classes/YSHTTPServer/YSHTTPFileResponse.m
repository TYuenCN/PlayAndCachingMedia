//
//  YSHTTPFileResponse.m
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import "YSHTTPConnection.h"
#import "YSHTTPFileResponse.h"
#import "YSCacheAbilityRemoteFileProvider.h"
@interface YSHTTPFileResponse()
{
    BOOL needBreakWhile;
    UInt64 localFileRealLength;
    UInt64 remoteFileRealLength;
}
@end

@implementation YSHTTPFileResponse

- (id)initWithFilePath:(NSString *)fpath forConnection:(HTTPConnection *)parent
{
    self = [super initWithFilePath:fpath forConnection:parent];
    localFileRealLength = fileLength;
    
    //
    //  To modify "fileLength" fields.
    //
    //  Because if is now caching, the total length which file of request, will not be the remote-file-real-total-length.
    //  It's will be the bytes count that has been loaded.
    //
    //  This to reset the fields of "fileLength" to the remote-file-real-total-length, Then Other-Object could carry on keep to load (or wait to load)
    //  even if has been finished load cache file bytes.
    //
    //  Other object keep downloading and cache the file. HTTPServer keep uploading the cache file to another object.
    //
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:CACHE_INFO_ARCHIVE_FILE_PATH]) {
        NSDictionary *cacheDic = [NSKeyedUnarchiver unarchiveObjectWithFile:CACHE_INFO_ARCHIVE_FILE_PATH];
        NSNumber *cachedFileRealLength = [cacheDic objectForKey:[fpath lastPathComponent]];
        remoteFileRealLength = [cachedFileRealLength longLongValue];
        fileLength = remoteFileRealLength;
    }
    
    //
    //  释放资源，需要停止所有的操作。如：
    //          在避免播放过程中，播放器请求本地正在下载并缓存的内容，请求的大小，比缓存的大－－
    //      现在为在While内，循环等待缓存的数据足够播放器的本次请求才返回，在中途退出后，while循环能一直存在，
    //      导致本对象及Response对象，一直存在；
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopAllOperation)
                                                 name:YSHTTP_CONNECTION_STOP_ALL_OPERATION
                                               object:nil];
    
    
    return self;
}


- (NSData *)readDataOfLength:(NSUInteger)length
{
    //
    //设定文件大小为本地实际缓存的文件大小，以防止实际缓存大小与第一次请求文件返回的服务器文件实际大小不一致，
    //导致请求本地Server数据同步不上。
    //
    fileLength = localFileRealLength;
    
    //
    //  判断的请求的字节长度范围，缓存的数据能否提供；
    //  不能提供，则循环内Sleep等待，逐步尝试；
    //
    //  如果Flag－needBreakWhile，指外围已经停止，防止卡在循环内不退出，和，不释放本类对象；
    //
    NSData *data;
    int64_t bytesLeftInFile = fileLength - fileOffset;
    while (bytesLeftInFile < length) {
        if (needBreakWhile) {
            return nil;
        }
        
        NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if (fileAttributes == nil)
        {
            NSLog(@"%s: Init failed - Unable to get file attributes. filePath: %@", __FILE__, filePath);
            return nil;
        }
        fileLength = (UInt64)[[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
        bytesLeftInFile = fileLength - fileOffset;
    }
    
    //
    //  请求的字节长度范围，缓存的数据能提供的时候，开始走正常HTTPServer类的流程
    //
    data = [super readDataOfLength:length];
    
    //
    //  重设置为Remote服务器的文件的实际大小，而不是已经缓存的大小
    //
    fileLength = remoteFileRealLength;
    
    return data;
}

#pragma mark - Lifecycle
- (void)dealloc
{
    //  注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Handler

//
//  要求停止所有服务的Notification Handler
//
- (void)stopAllOperation
{
    needBreakWhile = YES;
}
@end
