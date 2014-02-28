//
//  NSString+MD5Addition.m
//  UIDeviceAddition
//
//  Created by Yuen Cheng on 13-11-4.
//  Copyright (c) 2013年 YuenSoft.com. All rights reserved.
//

#import "NSString+MD5Addition.h"
#import <CommonCrypto/CommonDigest.h>



@implementation NSString(MD5Addition)

+ (NSString *)MD5WithCString:(const char *)data
{
    if(data == NULL)
        return nil;
    
    const char *value = data;
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    #if !__has_feature(objc_arc)
    return [outputString autorelease];
    #else
    return outputString;
    #endif
}

+ (NSString *) MD5WithString:(NSString *)originalString
{
    return [NSString MD5WithCString:[originalString UTF8String]];
}

- (NSString *) MD5{
    return [NSString MD5WithCString:[self UTF8String]];
}

@end
