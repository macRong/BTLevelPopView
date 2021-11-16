//
//  UIView+InsideToast.h
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (InsideToast)

@property (nonatomic, assign) BOOL insideToastCenterInScreen; // 是否现在屏幕中间(默认是NO)
@property (nonatomic, assign) CGFloat insideToastTopMargin; // toast所在的View距离屏幕顶部的距离, 已处理了*0.5的逻辑, 传入正数会向上移动

///  toast 提示
/// @param message 提示信息
/// @param displayTime 信息显示的时间
- (void)showInsideToastMessage:(NSString *)message displayTime:(NSTimeInterval)displayTime;
- (void)showInsideToastMessage:(NSString *)message;
- (void)hiddenInsideToastRightNow;

@end

NS_ASSUME_NONNULL_END
