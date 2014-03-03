//
//  YSASIHTTPRequest.m
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-3-3.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import "YSASIHTTPRequest.h"

@interface YSASIHTTPRequest ()
@end

@implementation YSASIHTTPRequest

- (void)handleStreamComplete
{
//    NSString *temporaryPath = [self temporaryFileDownloadPath];
//    NSString *destinationPath = [self downloadDestinationPath];
    [self setTemporaryFileDownloadPath:nil];
    [self setDownloadDestinationPath:nil];
    
    [super handleStreamComplete];
}
@end
