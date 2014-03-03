//
//  YSHTTPConnection.h
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//
#ifndef YSHTTPConnection_H
#define YSHTTPConnection_H
#import "HTTPConnection.h"

//
//  释放资源，需要停止所有的操作。如：
//          在避免播放过程中，播放器请求本地正在下载并缓存的内容，请求的大小，比缓存的大－－
//      现在为在While内，循环等待缓存的数据足够播放器的本次请求才返回，在中途退出后，while循环能一直存在，
//      导致本对象及Response对象，一直存在；
//
#define YSHTTP_CONNECTION_STOP_ALL_OPERATION @"YSHTTP_CONNECTION_STOP_ALL_OPERATION"

@interface YSHTTPConnection : HTTPConnection

@end
#endif