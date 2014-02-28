//
//  NSString+MD5Addition.h
//  UIDeviceAddition
//
//  Created by Yuen Cheng on 13-11-4.
//  Copyright (c) 2013年 YuenSoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(MD5Addition)

+ (NSString *) MD5WithCString:(const char *)data;
+ (NSString *) MD5WithString:(NSString *)originalString;
- (NSString *) MD5;

@end
