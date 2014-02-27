//
//  YSCacheAbilityRemoteFileProvider.m
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import "YSCacheAbilityRemoteFileProvider.h"
#import "NSString+MD5Addition.h"
#import "ASIHTTPRequest.h"
#import "HTTPServer.h"
#import "YSHTTPConnection.h"


@interface YSCacheAbilityRemoteFileProvider() <ASIHTTPRequestDelegate>
{
    BOOL isNotCachedAnything;
}
@property (nonatomic, strong) NSURL *remoteURL;
@property (nonatomic, strong) NSString *cachedFileName;
@property (nonatomic, strong) NSString *cachedFilePath;
@property (nonatomic, strong) NSMutableDictionary *cacheInfoDic;
@property (nonatomic, strong) HTTPServer *httpServer;
@property (nonatomic, strong) ASIHTTPRequest *request;
@end

@implementation YSCacheAbilityRemoteFileProvider
//@synthesize cacheDirectoryPath;
@synthesize delegate;
@synthesize remoteURL;
@synthesize cachedFileName;
@synthesize cachedFilePath;
@synthesize cacheInfoDic;
@synthesize httpServer;

- (id)initWithRemoteURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.remoteURL = url;
        [self checkCacheDirectory];
        [self checkArchiverFile];
        [self configureCachedFileProperty];
        [self configureCacheInfoDic];
    }
    
    return self;
}

//
//  是否存在缓存目录，不存在，创建
//
- (void)checkCacheDirectory
{
    NSError *err;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:DEFAULT_CACHE_DIRECTORY_PATH])
    {
        [fileManager createDirectoryAtPath:DEFAULT_CACHE_DIRECTORY_PATH
               withIntermediateDirectories:YES
                                attributes:Nil
                                     error:&err];
        if (err) {
            NSLog(@"Create cache directory error: %@", [err description]);
        }
    }
}

//
//  是否存在缓存记录文件，不存在，创建
//
- (void)checkArchiverFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *archiverFilePath = CACHE_INFO_ARCHIVE_FILE_PATH;
    if (![fileManager fileExistsAtPath:archiverFilePath])
    {
        self.cacheInfoDic = [NSMutableDictionary dictionary];
        
        //保存Archiver
        BOOL ok = [NSKeyedArchiver archiveRootObject:self.cacheInfoDic toFile:CACHE_INFO_ARCHIVE_FILE_PATH];
        if (!ok) {
            NSLog(@"归档‘综合缓存信息Dic’出错。");
        }
        //[fileManager createFileAtPath:archiverFilePath contents:nil attributes:nil];
    }
}

//
//  根据RemoteURL，获取本地缓存用的文件名、全路径，并保存到相关Property
//
- (void)configureCachedFileProperty
{
    NSString *cacheFileBaseName = [[self.remoteURL path] MD5];
    NSString *cacheFileName = [cacheFileBaseName stringByAppendingPathExtension:[self.remoteURL.path pathExtension]];
    [self setCachedFileName:cacheFileName];
    [self setCachedFilePath:[DEFAULT_CACHE_DIRECTORY_PATH stringByAppendingPathComponent:self.cachedFileName]];
    
    NSLog(@"cacheFile name is : %@", self.cachedFileName);
    NSLog(@"cacheFile path is : %@", self.cachedFilePath);
}

//
//  配置、保存：缓存综合信息归档文件
//
- (void)configureCacheInfoDic
{
    self.cacheInfoDic = [NSKeyedUnarchiver unarchiveObjectWithFile:CACHE_INFO_ARCHIVE_FILE_PATH];
}

//
//  开始创建缓存文件，并开始下载
//
- (void)prepareProvider
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //
    //  从来没有缓存过，直接开始下载，缓存过程
    //
    if (![fileManager fileExistsAtPath:self.cachedFilePath]) {
        [self startCaching];
        return;
    }
    
    //
    //  判断缓存文件是否存在
    //
    NSNumber *cachedFileRealLength = [self.cacheInfoDic objectForKey:self.cachedFileName];
    long long cachedFileLength = [[fileManager attributesOfItemAtPath:self.cachedFilePath error:nil] fileSize];
    
    //  全部缓存完成，直接开启本地服务，并，通知代理对象
    //  全部缓存完成，不应该开启HTTPServer了，直接返回本地地址
    if (cachedFileLength == [cachedFileRealLength longLongValue]) {
        NSURL *url = [NSURL fileURLWithPath:cachedFilePath];
        [self.delegate provider:self isStartCachingToLocalFileURL:url];
    }
    else    //  不是缓存完成的文件，开始下载缓存的过程
    {
        [self startCaching];
        return;
    }
}

- (void)startCaching
{
    self.request =[[ASIHTTPRequest alloc] initWithURL:self.remoteURL];
    //下载完存储目录
    [self.request setDownloadDestinationPath:self.cachedFilePath];
    //临时存储目录
    [self.request setTemporaryFileDownloadPath:self.cachedFilePath];
    //断点续载
    [self.request setAllowResumeForFileDownloads:YES];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}

//
//  开启本地服务，准备提供正在缓存的文件服务；
//  通知代理对象，提供URL，之后就可以开始使用；
//
- (void)startServer
{
    //开启HTTPServer
    // Create server using our custom MyHTTPServer class
    self.httpServer = [[HTTPServer alloc] init];
    [self.httpServer setConnectionClass:[YSHTTPConnection class]];
	
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [self.httpServer setType:@"_http._tcp."];
	
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    //[httpServer setPort:12345];
    
    // Serve files from our embedded Web folder
    [self.httpServer setDocumentRoot:DEFAULT_CACHE_DIRECTORY_PATH];
    
    // Start the server (and check for problems)
	
    NSError *error;
    if([self.httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [self.httpServer listeningPort]);
        // 通知代理对象，本地缓存的文件的URL
        NSURL *localCacheFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:%d/%@", [self.httpServer listeningPort], self.cachedFileName]];
        [self.delegate provider:self isStartCachingToLocalFileURL:localCacheFileURL];
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

- (void)dealloc
{
    [self.httpServer stop];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    if (![self.cacheInfoDic objectForKey:self.cachedFileName]) {
        //保存入，综合缓存信息Dic
        [self.cacheInfoDic setObject:[responseHeaders objectForKey:@"Content-Length"] forKey:self.cachedFileName ];
        NSLog(@"Real Length: %@", [responseHeaders objectForKey:@"Content-Length"]);
        
        //保存Archiver
        BOOL ok = [NSKeyedArchiver archiveRootObject:self.cacheInfoDic toFile:CACHE_INFO_ARCHIVE_FILE_PATH];
        if (!ok) {
            NSLog(@"归档‘综合缓存信息Dic’出错。");
        }
    }
    
    //开启Local HTTPServer
    //通知代理，开始提供本地服务
    [self startServer];
}

@end
