//
//  BTSelectLevelPopView.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "BTSelectLevelPopView.h"
#import "BTSelectLevelTitleView.h"
#import "BTSelectLevelView.h"
#import <Masonry/Masonry.h>
#import "UIView+CornerRadius.h"
#import "UIView+InsideToast.h"

@interface BTSelectLevelPopView()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) BTSelectLevelTitleView *titleView;
@property (nonatomic, strong) BTSelectLevelView *levelView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation BTSelectLevelPopView
@synthesize popViewHeight = _popViewHeight;

#pragma mark -  —————————————————— LifeCycle ——————————————————

- (void)dealloc
{
    
}

+ (instancetype)popView
{
    CGFloat heigth = [BTSelectLevelPopView viewHeiht];
    CGRect rect = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - heigth, [[UIScreen mainScreen] bounds].size.width, heigth);
    BTSelectLevelPopView *popView = [[BTSelectLevelPopView alloc]initWithFrame:rect];
    popView.backgroundColor = [UIColor redColor];
    
    return popView;
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
    _popViewHeight = [BTSelectLevelPopView viewHeiht];
}

+ (CGFloat)viewHeiht
{
    return [[UIScreen mainScreen] bounds].size.height*0.7;
}

/** 创建相关子view */
- (void)initViews
{
    __weak typeof(self) weakSelf = self;

    ///圆角
    self.clipsToBounds = YES;
    [self acs_radiusWithRadius:10 corner:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    ///Titlte
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(66);
    }];
    
    self.titleView.closeBlock = ^{
       if(weakSelf) [weakSelf close];
    };
    
    ///levelview
    [self addSubview:self.levelView];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.bottom.left.right.mas_equalTo(self);
    }];
}

#pragma mark - ——————————————— Public Funcation ———————————————

- (void)setDataModel:(BTSelectLevelModel *)dataModel
{
    _dataModel = dataModel;
    self.levelView.dataModel = dataModel;
    self.levelView.dataList = dataModel.dataList;

    self.titleView.titleLabel.text = dataModel.title;
    self.titleView.desLabel.text = dataModel.des;
}

- (void)show
{
    UIView *sView = [self windowSupView];
    if (self.bgView.window || [sView.subviews containsObject:self.bgView]) {
        return;
    }
    
    [sView addSubview:self.bgView];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sView);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self upProcessView];
    });
}

- (void)close
{
    if (!_bgView) {
        return;
    }
    
    __block CGRect rect = self.frame;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
        rect.origin.y = [[UIScreen mainScreen] bounds].size.height;
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];
}

#pragma mark - ——————————————— Private Funcation ——————————————

- (void)upProcessView
{
    if (self.window) {
        return;
    }
    
    [self.bgView addSubview:self];
    __block CGRect rect = self.frame;
    [UIView animateWithDuration:.25 animations:^{
        self.bgView.alpha = 1;
        rect.origin.y = [[UIScreen mainScreen] bounds].size.height - self.popViewHeight;
        self.frame = rect;
    }];
}

- (UIView *)windowSupView
{
    return [UIApplication sharedApplication].windows.firstObject;
}

#pragma mark - —————————————————— Touch Event  ————————————————

- (void)gesAction
{
    [self close];
}

- (void)doCloseAction:(UIButton*)sender
{
    [self close];
}

#pragma mark - ———————————————— Setter/Getter  ————————————————

- (void)setPopViewHeight:(CGFloat)popViewHeight
{
    _popViewHeight = popViewHeight;
    CGRect rect = self.frame;
    rect.size.height = popViewHeight;
    rect.origin.y = [[UIScreen mainScreen] bounds].size.height - popViewHeight;
    self.frame = rect;
}

- (CGFloat)popViewHeight
{
    if (_popViewHeight > 0) {
        return _popViewHeight;
    }
    
    _popViewHeight = [BTSelectLevelPopView viewHeiht];
    return _popViewHeight;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    
    return _bgView;
}

- (UIButton*)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor clearColor];
        _closeBtn.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
        [_closeBtn addTarget:self action:@selector(doCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}

- (BTSelectLevelTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[BTSelectLevelTitleView alloc]init];
    }
    
    return _titleView;
}

- (BTSelectLevelView *)levelView
{
    if (!_levelView) {
        _levelView = [[BTSelectLevelView alloc]init];
        __weak typeof(self) weakSelf = self;
        _levelView.confirmSelectItemsBlock = ^(NSArray<BTSelectLevelItemModel *> * _Nonnull modes, BTSelectLevelModel *dataModel) {
            ///没有选择
            if (modes.count <= 0 && weakSelf.dataModel.minlimitCount > 0) {
                if (weakSelf.dataModel.minlimitMsg.length <= 0) {
                    [weakSelf showInsideToastMessage:weakSelf.dataModel.minlimitMsg];
                    return;
                }
                
                [weakSelf showInsideToastMessage:@"至少选择一个"];
                return;
            }
            
            if (weakSelf.confirmSelectItemsBlock) {
                weakSelf.confirmSelectItemsBlock(modes, dataModel);
            }
            
           if(weakSelf) [weakSelf close];
        };
    }
    
    return _levelView;
}

@end
