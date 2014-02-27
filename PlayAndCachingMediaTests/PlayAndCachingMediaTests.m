//
//  PlayAndCachingMediaTests.m
//  PlayAndCachingMediaTests
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSCacheAbilityRemoteFileProvider.h"

@interface PlayAndCachingMediaTests : XCTestCase

@end

@implementation PlayAndCachingMediaTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testYSCacheAbilityRemoteFileProviderInit
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    YSCacheAbilityRemoteFileProvider *provider = [[YSCacheAbilityRemoteFileProvider alloc] initWithRemoteURL:[NSURL URLWithString:@"http://adfa.oss-cn-qingdao.aliyuncs.com/demo.mp4"]];
}

@end
