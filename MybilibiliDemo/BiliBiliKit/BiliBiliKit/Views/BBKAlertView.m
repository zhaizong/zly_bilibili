//
//  BBKAlertView.m
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/19.
//  Copyright © 2016年 Zly. All rights reserved.
//

#import "BBKAlertView.h"

static inline BOOL versionBigger9() {
  
  float sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
  
  if (sysVersion >= 9.0) {
    return YES;
  } else {
    return NO;
  }
}

@interface UIView (BBKSearchVcExtend)

- (UIViewController *)viewController;

@end

@implementation UIView (BBKSearchVcExtend)

- (UIViewController *)viewController {
  
  for (UIView* next = self; next; next = next.superview) {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
      return (UIViewController*)nextResponder;
    }
  }
  return nil;
}

@end

@interface BBKAlertView()<UIAlertViewDelegate>

/** 按钮点击触发的回调 */
@property (nonatomic, copy) BBKAlertViewBlock block;

@end

@implementation BBKAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  
  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  
  [super willMoveToSuperview:newSuperview];
  self.frame = newSuperview.bounds;
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
}

- (void)showWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButtonTitle:(NSString *)cancelButtonTitle andOtherButtonTitles:(NSArray *)otherButtonTitles {
  
  UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
  for (NSString *otherTitle in otherButtonTitles) {
    [alertView addButtonWithTitle:otherTitle];
  }
  [alertView show];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles andAction:(BBKAlertViewBlock)block andParentView:(UIView *)view {
  
  if (versionBigger9()) {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __block BBKAlertView *alert = [[BBKAlertView alloc]init];
    alert.block = block;
    
    if (cancelButtonTitle) {
      UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (alert.block) {
          alert.block(0);
        }
      }];
      [alertVc addAction:action];
    }
    if (view == nil) {
      UIWindow *window = [UIApplication sharedApplication].keyWindow;
      [window.rootViewController presentViewController:alertVc animated:YES completion:nil];
    } else {
      [[view viewController] presentViewController:alertVc animated:YES completion:nil];
    }
  } else {
    if (view == nil) {
      
    }
    view = [[UIApplication sharedApplication].windows lastObject];
    BBKAlertView *alert = [[BBKAlertView alloc]init];
    [alert showWithTitle:title andMessage:message andCancelButtonTitle:cancelButtonTitle andOtherButtonTitles:otherButtonTitles];
    alert.block = block;
    [view addSubview:alert];
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (self.block) {
    self.block(buttonIndex);
  }
//  点击事件完成需要将视图移除
  [self removeFromSuperview];
}

@end

