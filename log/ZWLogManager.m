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

#import "ZWLogManager.h"

@implementation ZWLogManager

//
//  配置DDLog，开始使用；
//
+ (void)startLogManager
{
    //
    //  Log Console
    //
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    //
    //  Log File
    //
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;//保留一周的Log
    [DDLog addLogger:fileLogger];
}

@end
