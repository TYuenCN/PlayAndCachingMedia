//
//  YSAppDelegate.h
//  PlayAndCachingMedia
//
//  Created by sxzw on 14-2-26.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCacheAbilityRemoteFileProvider.h"

@interface YSAppDelegate : UIResponder <UIApplicationDelegate, YSCacheAbilityRemoteFileProviderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) YSCacheAbilityRemoteFileProvider *provider;
@end
