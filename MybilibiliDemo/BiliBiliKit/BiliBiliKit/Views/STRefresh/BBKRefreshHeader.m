//
//  BBKRefreshHeader.m
//  HalfSugarMainPage
//
//  Created by 宅总 on 16/9/15.
//  Copyright © 2016年 Crazy. All rights reserved.
//

#import "BBKRefreshHeader.h"
#import "UIView+BBKFrame.h"
#import <objc/message.h>

#define RGBColor(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kSTRefreshCircleLineWidth   2.5
#define kSTRefreshRoundTime         1.5

typedef NS_ENUM(NSInteger,BBKRefreshState) {
    BBKRefreshStateNormal,
    BBKRefreshStatePulling,
    BBKRefreshStateRefeshing,
    BBKRefreshStateWillRefesh
};


@interface BBKRefreshHeader ()

@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, strong) CAShapeLayer * circleLayer;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIImageView * headerImageV;
@property (nonatomic, strong) NSArray * colorArray;
@property (nonatomic, assign) CGFloat orginContentInsetTop;
@property (nonatomic, assign) BBKRefreshState state;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, copy) void(^refreshingBlock)(BBKRefreshHeader *);
@property (weak, nonatomic) id refreshingTarget;
@property (assign, nonatomic) SEL refreshingAction;

@end


static void * BBKRefreshContentOffsetContext             = &BBKRefreshContentOffsetContext;
static void * BBKRefreshcontentInsetContext              = &BBKRefreshcontentInsetContext;

@implementation BBKRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(void(^)(BBKRefreshHeader * header))refreshingBlock {
    BBKRefreshHeader * header = [[BBKRefreshHeader alloc]init];
    header.refreshingBlock = refreshingBlock;
    return header;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    BBKRefreshHeader * header = [[BBKRefreshHeader alloc]init];
    header.refreshingTarget = target;
    header.refreshingAction = action;
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.st_y      = - kBBKRefreshHeaderHeight;
    self.st_height = kBBKRefreshHeaderHeight;
    self.state = BBKRefreshStateNormal;
    self.colorArray = @[RGBColor(240, 128, 128),
                        RGBColor(124, 205, 124),
                        RGBColor(224, 238, 224)];
    
    // content
    self.contentView = [UIView new];
    _contentView.st_size = CGSizeMake(kSTRefreshImageWidth, kSTRefreshImageWidth);
    _contentView.st_centerY = self.st_height;
    _contentView.alpha = 0;
    
    // image
    self.headerImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"github"]];
    _headerImageV.frame = _contentView.bounds;
    _headerImageV.layer.masksToBounds = YES;
    
    // circle layer
    self.circleLayer = [[CAShapeLayer alloc]init];
    _circleLayer.frame = _contentView.bounds;
    _circleLayer.fillColor = nil;
    _circleLayer.lineWidth = kSTRefreshCircleLineWidth;
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.strokeStart = 0;
    _circleLayer.strokeEnd = 0;
    _circleLayer.strokeColor = [(UIColor *)_colorArray.firstObject CGColor];
    
    CGPoint center = CGPointMake(_contentView.st_width / 2.0, _contentView.st_height / 2.0);
    CGFloat radius = _contentView.st_height/2.0 - _circleLayer.lineWidth / 2.0;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = 2*M_PI - M_PI_2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    _circleLayer.path = path.CGPath;
    
    [self addSubview:_contentView];
    [_contentView addSubview:_headerImageV];
    [_contentView.layer addSublayer:_circleLayer];
}

- (void)startLoadingAnimation {
    if (!_isAnimating) {
        [self.circleLayer removeAllAnimations];
    }
    _isAnimating = YES;
    
    // Stroke Head
    CABasicAnimation *headAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation1.fromValue = @0;
    headAnimation1.toValue = @0.25;
    headAnimation1.duration = kSTRefreshRoundTime/3.0;
    headAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *headAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation2.beginTime = kSTRefreshRoundTime/3.0;
    headAnimation2.fromValue = @0.25;
    headAnimation2.toValue = @1;
    headAnimation2.duration = 2*kSTRefreshRoundTime/3.0;
    headAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Stroke Tail
    CABasicAnimation *tailAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation1.fromValue = @0.25;
    tailAnimation1.toValue = @0.85;
    tailAnimation1.duration = kSTRefreshRoundTime/3.0;
    tailAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *tailAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation2.beginTime = kSTRefreshRoundTime/3.0;
    tailAnimation2.fromValue = @0.85;
    tailAnimation2.toValue = @1.25;
    tailAnimation2.duration = 2*kSTRefreshRoundTime/3.0;
    tailAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Stroke Line Group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = kSTRefreshRoundTime;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[headAnimation1, headAnimation2, tailAnimation1, tailAnimation2];
    
    // Rotation
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2*M_PI);
    rotationAnimation.duration = kSTRefreshRoundTime;
    rotationAnimation.repeatCount = INFINITY;
    
    CAKeyframeAnimation *strokeColorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    strokeColorAnimation.values = [self prepareColorValues];
    strokeColorAnimation.keyTimes = [self prepareKeyTimes];
    strokeColorAnimation.calculationMode = kCAAnimationDiscrete;
    strokeColorAnimation.duration = self.colorArray.count *kSTRefreshRoundTime;
    strokeColorAnimation.repeatCount = INFINITY;
    
    [self.circleLayer addAnimation:animationGroup forKey:nil];
    [self.circleLayer addAnimation:rotationAnimation forKey:nil];
    [self.circleLayer addAnimation:strokeColorAnimation forKey:nil];
}

- (void)stopLoadingAnimation {
    if (_isAnimating) {
        [self.circleLayer removeAllAnimations];
    }
    _isAnimating = NO;
    [self.circleLayer setStrokeStart:0];
    [self.circleLayer setStrokeEnd:1];
    [self.circleLayer setStrokeColor:[(UIColor *)_colorArray.firstObject CGColor]];
}

- (NSArray*)prepareColorValues {
    NSMutableArray *cgColorArray = [[NSMutableArray alloc] init];
    for(UIColor *color in self.colorArray){
        [cgColorArray addObject:(id)color.CGColor];
    }
    return cgColorArray;
}

- (NSArray*)prepareKeyTimes {
    NSMutableArray *keyTimesArray = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0; i < self.colorArray.count + 1; i ++){
        [keyTimesArray addObject:[NSNumber numberWithFloat:i *1.0/self.colorArray.count]];
    }
    return keyTimesArray;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];
    
    if (nil != newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.st_width = newSuperview.st_width;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        [self addObservers];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.st_centerX = self.st_width/2;
}

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:BBKRefreshContentOffsetContext];
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:options context:BBKRefreshcontentInsetContext];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentInset"];;
}

#pragma mark - observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == BBKRefreshcontentInsetContext) {
        if (_state != BBKRefreshStateRefeshing) {
            UIEdgeInsets contentInsets = [change[NSKeyValueChangeNewKey] UIEdgeInsetsValue];
            _orginContentInsetTop = contentInsets.top;
        }
    }
    
    else if (context == BBKRefreshContentOffsetContext) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat moveOffsetY   =  _orginContentInsetTop + contentOffset.y;
        if (moveOffsetY > 0) {
            return;
        }
        moveOffsetY = - moveOffsetY;
        _contentView.st_centerY = self.st_height - moveOffsetY/2;
        
        // 拖拽
        if (self.scrollView.isDragging) {
            
            CGFloat pullPercent = fmin(moveOffsetY/kBBKRefreshHeaderHeight, 1);
            _circleLayer.strokeEnd = pullPercent;
            _contentView.alpha = pullPercent;
            _headerImageV.transform = CGAffineTransformMakeRotation(pullPercent * (M_PI - 0.001));
            
            if (self.state == BBKRefreshStateRefeshing) {
                return;
            }
            self.state = BBKRefreshStatePulling;
            
            if (moveOffsetY > kBBKRefreshHeaderHeight) {
                self.state = BBKRefreshStateWillRefesh;
            }
        }
        // 松手刷新 或 返回
        else {
            if (self.state == BBKRefreshStateWillRefesh) {
                [self beganRefreshing];
            }else if (self.state != BBKRefreshStateNormal) {
                
                CGFloat pullPercent = fmin(moveOffsetY/kBBKRefreshHeaderHeight, 1);
                _circleLayer.strokeEnd = pullPercent;
                _contentView.alpha = pullPercent;
                _headerImageV.transform = CGAffineTransformMakeRotation(pullPercent * (M_PI - 0.001));
                
            }
        }
    }
}

- (void)beganRefreshing {
    self.state = BBKRefreshStateRefeshing;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.contentView.st_centerY = self.st_height/2;
        
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top = _orginContentInsetTop + kBBKRefreshHeaderHeight;
        
        self.scrollView.contentInset = contentInset;
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, - contentInset.top);
        
    } completion:^(BOOL finished) {
        [self startLoadingAnimation];
        [self executeRefreshingCallback];
    }];
}

- (void)endRefreshing {
    if (self.state != BBKRefreshStateRefeshing) {
        return;
    }
    self.state = BBKRefreshStateNormal;
    
    [self stopLoadingAnimation];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top -= kBBKRefreshHeaderHeight;
        self.scrollView.contentInset = contentInset;
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, - contentInset.top);
        
        self.contentView.st_centerY = self.st_height;
        self.contentView.alpha = 0;
        self.circleLayer.strokeEnd = 0;
        self.headerImageV.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)executeRefreshingCallback {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock(self);
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            ((void (*)(void *, SEL, UIView *))objc_msgSend)((__bridge void *)(self.refreshingTarget),self.refreshingAction, self);
        }
    });
}

@end






