//
//  UIScrollView+STRefresh.h
//  HalfSugarMainPage
//
//  Created by 宅总 on 16/9/15.
//  Copyright © 2016年 Crazy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBKRefreshHeader.h"

@interface UIScrollView (BBKRefresh)

@property (nonatomic, strong) BBKRefreshHeader * header;

@end
