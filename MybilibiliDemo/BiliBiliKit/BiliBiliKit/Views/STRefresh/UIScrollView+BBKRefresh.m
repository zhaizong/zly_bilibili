//
//  UIScrollView+STRefresh.h
//  HalfSugarMainPage
//
//  Created by 宅总 on 16/9/15.
//  Copyright © 2016年 Crazy. All rights reserved.
//

#import "UIScrollView+BBKRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (BBKRefresh)

- (BBKRefreshHeader *)header {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHeader:(BBKRefreshHeader *)header {
    [self.header removeFromSuperview];
    [self addSubview:header];
    
    SEL key = @selector(header);
    objc_setAssociatedObject(self, key, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
