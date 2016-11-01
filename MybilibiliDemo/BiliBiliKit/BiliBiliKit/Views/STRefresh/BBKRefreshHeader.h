//
//  BBKRefreshHeader.h
//  HalfSugarMainPage
//
//  Created by 宅总 on 16/9/15.
//  Copyright © 2016年 Crazy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBBKRefreshHeaderHeight  60
#define kSTRefreshImageWidth    40

@interface BBKRefreshHeader : UIView

+ (instancetype)headerWithRefreshingBlock:(void(^)(BBKRefreshHeader * header))refreshingBlock;
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)beganRefreshing;
- (void)endRefreshing;

@end
