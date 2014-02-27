//
//  YSHTTPConnection.m
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import "YSHTTPConnection.h"
#import "YSHTTPFileResponse.h"

@implementation YSHTTPConnection
/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResponse is a wrapper for an NSData object, and may be used to send a custom response.
 **/
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    // Override me to provide custom responses.
	
	NSString *filePath = [self filePathForURI:path allowDirectory:NO];
	
	BOOL isDir = NO;
	
	if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
	{
		return [[YSHTTPFileResponse alloc] initWithFilePath:filePath forConnection:self];
        
		// Use me instead for asynchronous file IO.
		// Generally better for larger files.
		
        //	return [[[HTTPAsyncFileResponse alloc] initWithFilePath:filePath forConnection:self] autorelease];
	}
	
	return nil;
}
@end
