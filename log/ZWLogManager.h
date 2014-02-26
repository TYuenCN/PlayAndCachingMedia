//
//  ZWLogManager.h
//  vCard
//
//  日志系统，管理器
//
//  1、程序启动时，发送类消息+ (void)startLogManager，将配置并启动开始使用DDLog；
//  2、在使用DDLog输出日志的时候，可导入此Header；
//
//  Created by sxzw on 14-2-13.
//  Copyright (c) 2014年 sxzw. All rights reserved.
//

#ifndef vCard_ZWLogManager_h
#define vCard_ZWLogManager_h

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "DDFileLogger.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#import <Foundation/Foundation.h>

@interface ZWLogManager : NSObject

//配置DDLog，开始使用；
+ (void)startLogManager;
@end

#endif