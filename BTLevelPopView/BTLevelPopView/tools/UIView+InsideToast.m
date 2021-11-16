//
//  UIView+InsideToast.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "UIView+InsideToast.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

static NSString *insideToastCenterInScreenInViewKey = nil;
static NSString *insideToastTopMarginInViewKey = nil;
static NSString *insideToastInfoLabelInViewKey = nil;
static NSString *insideToastBellowInViewKey = nil;
static NSString *insideToastDisPlayTimeObjectInViewKey = nil;

#define KInsideToastInfoLabelInViewControllerMaxWidth (kScreenWidth * 0.65)
#define KInsideToastInfoLabelInViewControllerInsideMargin 10

@interface UIViewController ()

@property (nonatomic, weak) UILabel *insideToastInfoLabelInViewController;
@property (nonatomic, weak) UIView *insideToastBellowInViewController;
@property (nonatomic, assign) NSNumber *insideToastDisPlayTimeObjectInViewController;

@end

@implementation UIView (InsideToast)

- (void)setInsideToastDisPlayTimeObjectInViewController:(NSNumber *)insideToastDisPlayTimeObjectInViewController
{    
    objc_setAssociatedObject(self, &insideToastDisPlayTimeObjectInViewKey, insideToastDisPlayTimeObjectInViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)insideToastDisPlayTimeObjectInViewController{
    
    return objc_getAssociatedObject(self, &insideToastDisPlayTimeObjectInViewKey);
}

- (void)setInsideToastBellowInViewController:(UIView *)insideToastBellowInViewController{
    
    objc_setAssociatedObject(self, &insideToastBellowInViewKey, insideToastBellowInViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)insideToastBellowInViewController{
    
    return objc_getAssociatedObject(self, &insideToastBellowInViewKey);
}

- (void)setInsideToastCenterInScreen:(BOOL)insideToastCenterInScreen{
    
    objc_setAssociatedObject(self, &insideToastCenterInScreenInViewKey, [NSNumber numberWithBool:insideToastCenterInScreen], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (insideToastCenterInScreen) {
        //
        UIView *window = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [self convertRect:self.bounds toView:window];
        self.insideToastTopMargin = rect.origin.y;
    }else{
        
        self.insideToastTopMargin = 0;
    }
    if (objc_getAssociatedObject(self, &insideToastInfoLabelInViewKey) == nil) {
        
        [self insideToastInfoLabelInViewController];
    }else{
        
        [self updateBellowViewSize];
    }
}

- (BOOL)insideToastCenterInScreen{
    
    NSNumber *obj = objc_getAssociatedObject(self, &insideToastCenterInScreenInViewKey);
    return [obj boolValue];
}

- (void)setInsideToastTopMargin:(CGFloat)insideToastTopMargin{
    
    objc_setAssociatedObject(self, &insideToastTopMarginInViewKey, [NSNumber numberWithFloat:insideToastTopMargin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (objc_getAssociatedObject(self, &insideToastInfoLabelInViewKey) == nil) {
        
        [self insideToastInfoLabelInViewController];
    }else{
        
        [self updateBellowViewSize];
    }
}
- (CGFloat)insideToastTopMargin{
    
    NSNumber *obj = objc_getAssociatedObject(self, &insideToastTopMarginInViewKey);
    return [obj floatValue];
}

- (void)setInsideToastInfoLabelInViewController:(UILabel *)insideToastInfoLabelInViewController{
    
    objc_setAssociatedObject(self, &insideToastInfoLabelInViewKey, insideToastInfoLabelInViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)insideToastInfoLabelInViewController{
    
    if (objc_getAssociatedObject(self, &insideToastInfoLabelInViewKey) == nil) {
        
        UIView *bellowView = [UIView new];
        self.insideToastBellowInViewController = bellowView;
        bellowView.hidden = YES;
        bellowView.alpha = 0;
        bellowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        bellowView.layer.cornerRadius = 5;
        [self addSubview:bellowView];
        [bellowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(0.5));
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UILabel *label = [UILabel new];
        self.insideToastInfoLabelInViewController = label;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        label.text = @" ";
        [label sizeToFit];
        [bellowView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bellowView.mas_centerX);
            make.centerY.equalTo(bellowView.mas_centerY);
            make.width.equalTo(@(CGRectGetWidth(bellowView.frame)));
            make.height.equalTo(@(CGRectGetHeight(bellowView.frame)));
        }];
        
        [self updateBellowViewSize];
    }
    return objc_getAssociatedObject(self, &insideToastInfoLabelInViewKey);
}

- (void)updateInfoLabelSize{
    
    [self.insideToastInfoLabelInViewController mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(CGRectGetWidth(self.insideToastInfoLabelInViewController.frame)));
        make.height.equalTo(@(CGRectGetHeight(self.insideToastInfoLabelInViewController.frame)));
        make.centerX.equalTo(self.insideToastBellowInViewController.mas_centerX);
        make.centerY.equalTo(self.insideToastBellowInViewController.mas_centerY);
    }];
}

- (void)updateBellowViewSize{
    
    [self.insideToastBellowInViewController mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(CGRectGetWidth(self.insideToastInfoLabelInViewController.frame) + KInsideToastInfoLabelInViewControllerInsideMargin * 2));
        make.height.equalTo(@(CGRectGetHeight(self.insideToastInfoLabelInViewController.frame) + KInsideToastInfoLabelInViewControllerInsideMargin * 2));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-self.insideToastTopMargin * 0.5);
    }];
}

- (void)showInsideToastMessage:(NSString *)message{
    
    [self showInsideToastMessage:message displayTime:1.5];
}
- (void)showInsideToastMessage:(NSString *)message displayTime:(NSTimeInterval)displayTime{
    
    if (!message.length) {
        return;
    }
    
    // 短时间相同toast不重复展示
    if ([message isEqualToString:self.insideToastInfoLabelInViewController.text]) {
        return;
    }
    
    self.insideToastInfoLabelInViewController.text = message;
    self.insideToastInfoLabelInViewController.numberOfLines = 1;
    self.insideToastInfoLabelInViewController.textAlignment = NSTextAlignmentLeft;
    [self.insideToastInfoLabelInViewController sizeToFit]; // 宽度自适应
    self.insideToastBellowInViewController.hidden = NO;
    [self bringSubviewToFront:self.insideToastBellowInViewController];
    
    // 判断宽度是否超长
    if (CGRectGetWidth(self.insideToastInfoLabelInViewController.frame) > [[UIScreen mainScreen] bounds].size.width*0.65) {
        self.insideToastInfoLabelInViewController.numberOfLines = 0;
        CGRect rect = self.insideToastInfoLabelInViewController.frame;
        rect.size.width = [[UIScreen mainScreen] bounds].size.width*0.65;
        self.insideToastInfoLabelInViewController.frame = rect;
        [self.insideToastInfoLabelInViewController sizeToFit]; // 宽度自适应
        self.insideToastInfoLabelInViewController.textAlignment = NSTextAlignmentCenter;
    }
    
    [self updateBellowViewSize];
    [self updateInfoLabelSize];
    
    // 取消之前的延时动作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHiddenInsideToastInViewController) object:nil];
    self.insideToastBellowInViewController.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.insideToastBellowInViewController.alpha = 1;
    } completion:^(BOOL finished) {
        
        self.insideToastDisPlayTimeObjectInViewController = @(displayTime);
        [self performSelector:@selector(delayHiddenInsideToastInViewController) withObject:nil afterDelay:displayTime];
    }];
}

- (void)delayHiddenInsideToastInViewController
{
    NSLog(@"将要隐藏了");
    [UIView animateWithDuration:0.5 animations:^{
        self.insideToastBellowInViewController.alpha = 0;
    } completion:^(BOOL finished) {
        self.insideToastBellowInViewController.hidden = YES;
        self.insideToastInfoLabelInViewController.text = nil;
    }];
}

- (void)hiddenInsideToastRightNow
{    
    // 取消之前的延时动作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHiddenInsideToastInViewController) object:nil];
    [UIView commitAnimations];
    self.insideToastBellowInViewController.alpha = 0;
    self.insideToastBellowInViewController.hidden = YES;
}

@end
