//
//  YSHTTPFileResponse.m
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import "YSHTTPFileResponse.h"
#import "YSCacheAbilityRemoteFileProvider.h"

@implementation YSHTTPFileResponse
- (id)initWithFilePath:(NSString *)fpath forConnection:(HTTPConnection *)parent
{
    self = [super initWithFilePath:fpath forConnection:parent];
    
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
        fileLength = [cachedFileRealLength longLongValue];
    }
    
    return self;
}
@end
