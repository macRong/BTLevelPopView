//
//  BTSelectLevelTitleView.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "BTSelectLevelTitleView.h"
#import <Masonry/Masonry.h>

@interface BTSelectLevelTitleView()


@end

@implementation BTSelectLevelTitleView
#pragma mark -  —————————————————— LifeCycle ——————————————————

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initVars];
        [self initViews];
    }
    
    return self;
}

/** 变量初始化 */
- (void)initVars
{
    
}

/** 创建相关子view */
- (void)initViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(self).inset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(24);
    }];
    
    [self addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).inset(6);
        make.height.mas_equalTo(20);
    }];
    
    ///关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [closeBtn setTitleColor:colorFromRGB(0x333333) forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 20));
        make.right.mas_equalTo(self).inset(14);
        make.top.mas_equalTo(self).inset(10);
    }];
    
    ///Lineview
    UIView *lineView = [UIView new];
    lineView.backgroundColor = colorFromRGB(0xe5e5e5);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - ——————————————— Public Funcation ———————————————

#pragma mark - ——————————————— Private Funcation ——————————————

#pragma mark - —————————————————— Touch Event  ————————————————

- (void)closeAction
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark - ———————————————— Setter/Getter  ————————————————

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _desLabel.textColor = colorFromRGB(0x333333);
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _desLabel;
}

static UIColor* colorFromRGB(long rbg)
{
    return [UIColor colorWithRed:((float)((rbg & 0xFF0000) >> 16))/255.0 green:((float)((rbg & 0xFF00) >> 8))/255.0 blue:((float)(rbg & 0xFF))/255.0 alpha:1.0];
}

@end
