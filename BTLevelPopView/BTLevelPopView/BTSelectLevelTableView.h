//
//  BTSelectLevelTableView.h
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import <UIKit/UIKit.h>
#import "BTSelectLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTSelectLevelTableView : UITableView

@property (nonatomic, strong) NSMutableArray <BTSelectLevelItemModel *>*dataListMArr;

@property (nonatomic, assign) BOOL visibleTableView; ///default： 第一级YES，其他NO
@property (nonatomic, assign) int tableviewIndex; ///第几个tableview defatul:0
@property (nonatomic, assign, nullable) BTSelectLevelItemModel *clickCurrentSelectItem; ///当前点击选中的Item(用于最后级动态更新前面item)
@property (nonatomic, weak, nullable) BTSelectLevelTableView *parentTabelView; ///上一级tableView

///根据后面级别选择动态改变前级别是否选中状态（一直到第一级）(前级别只设置YES)
- (void)updatePreTableViewSeletStatus;

///把当前tableView后面的tableview的clickCurrentSelectItem=nil
- (void)processInvalidForPreTableViewsCilckItems:(NSMutableArray <BTSelectLevelTableView *>*)tables;

///刷新单个cell
- (void)reloadRowForItemodel:(BTSelectLevelItemModel *)itemModel;

///删除所有选择（除了"全部"为选择）
- (void)removeAllAndUpdateAllItem:(NSMutableArray <BTSelectLevelItemModel *>*)resultMarr allItem:(BTSelectLevelItemModel *)allItem;
///删除“全部”，其他动 allItem:是要删除的
- (void)removeAllItem:(NSMutableArray <BTSelectLevelItemModel *>*)resultMarr allItem:(BTSelectLevelItemModel *)allItem;

@end

NS_ASSUME_NONNULL_END
