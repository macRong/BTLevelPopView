//
//  BTSelectLevelView.h
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

/**
 多级选择控件-Main
 */
#import <UIKit/UIKit.h>
#import "BTSelectLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTSelectLevelView : UIView

@property (nonatomic, strong) NSArray <BTSelectLevelItemModel *>* dataList; ///数据源
@property (nonatomic, strong) BTSelectLevelModel *dataModel; ///多级完整数据(参考用)

///确定回调
@property (nonatomic, copy) void(^confirmSelectItemsBlock)(NSArray <BTSelectLevelItemModel *>* modes, BTSelectLevelModel *dataModel);

@end

NS_ASSUME_NONNULL_END
