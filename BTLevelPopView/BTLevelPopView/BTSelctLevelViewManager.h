//
//  BTSelctLevelViewManager.h
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BTSelectLevelModel;
@class BTSelectLevelItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTSelctLevelViewManager : NSObject

///获取每一级tableview的color（arr：它的上级已经存的tableviews）
- (UIColor *)tableLevelColor:(NSArray *)arr;

#pragma mark -高亮逻辑

///把高亮数据先赋值给resultMarr
- (void)processSelectHightResultMarr:(NSMutableArray<BTSelectLevelItemModel *> *)resultMarr
                     selectDataModel:(BTSelectLevelModel *)selectDataModel;

///把选中item放入对应分类arr中
- (void)addSelectForSelectArrWith:(BTSelectLevelItemModel *)itemModel dataModel:(BTSelectLevelModel *)dataModel;
///把选中item在对应分类arr中删除
- (void)removeSelectForSelectArrWith:(BTSelectLevelItemModel *)itemModel dataModel:(BTSelectLevelModel *)dataModel;

///把高亮的item赋值到新的数据
- (void)processSelectHightItemModels:(NSArray <BTSelectLevelItemModel *>*)dataList
                               index:(NSInteger)index
                     selectDataModel:(BTSelectLevelModel *)selectDataModel;

#pragma mark -tools

///marr是否包含itemmodel（必须根据ids，不能是对象）
- (BOOL)containItem:(BTSelectLevelItemModel *)itemModel marr:(NSMutableArray <BTSelectLevelItemModel *> *)marr;
///数组中删除对应的ItemoModel（根据ids，不能是object）
- (BOOL)removeSelectItem:(BTSelectLevelItemModel *)item itemMarr:(NSMutableArray <BTSelectLevelItemModel *>*)itemMarr;
///添加ItemoModel（根据ids，不能是object）（过滤重复）
- (void)addSelectItem:(BTSelectLevelItemModel *)item itemMarr:(NSMutableArray <BTSelectLevelItemModel *>*)itemMarr;

#pragma mark - “全部”判断逻辑

///item是否是“全部”item
+ (BOOL)isAllItemModel:(BTSelectLevelItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
