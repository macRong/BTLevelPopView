//
//  BTSelectLevelTitleView.h
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTSelectLevelTitleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;

///关闭
@property (nonatomic, copy) dispatch_block_t closeBlock;

@end

NS_ASSUME_NONNULL_END
