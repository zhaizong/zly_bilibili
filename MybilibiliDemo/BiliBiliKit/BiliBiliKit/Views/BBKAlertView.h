//
//  BBKAlertView.h
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/19.
//  Copyright © 2016年 Zly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BBKAlertViewBlock)(NSInteger buttonIndex);

NS_ASSUME_NONNULL_BEGIN
@interface BBKAlertView : UIView

/**
 *  总方法
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles andAction:(BBKAlertViewBlock)block andParentView:(nullable UIView *)view;

@end
NS_ASSUME_NONNULL_END
