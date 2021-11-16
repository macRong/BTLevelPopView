//
//  UIView+CornerRadius.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (void)acs_radiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner
{
    if (@available(iOS 11.0, *))
    {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = (CACornerMask)corner;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = path.CGPath;
            self.layer.mask = maskLayer;
        });
    }
}

@end
