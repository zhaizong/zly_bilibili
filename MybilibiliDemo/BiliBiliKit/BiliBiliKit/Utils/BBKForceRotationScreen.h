//
//  BBKForceRotationScreen.h
//  BiliBiliKit
//
//  Created by Crazy on 16/11/29.
//  Copyright © 2016年 Zly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBKForceRotationScreen : NSObject

/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 *  是否是横屏
 *
 *  @return 是 返回yes
 */
+ (BOOL)isOrientationLandscape;

@end
