//
//  BTSelectLevelTableView.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "BTSelectLevelTableView.h"
#import "BTSelctLevelViewManager.h"

@interface BTSelectLevelTableView()


@end

@implementation BTSelectLevelTableView

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
    
}

#pragma mark - ——————————————— Public Funcation ———————————————

- (void)updatePreTableViewSeletStatus
{
    BOOL lastTableCotainSelectItem = [self containSelectItemForTableView:self];
    
    if (lastTableCotainSelectItem) { ///如果最后一级有选中，那么他前级都选中
        [self recursionPreSelectTable:self.parentTabelView];
    }else { ///如果最后一级没有选中，那么他前一级也不选中，在往前要判断...
        self.parentTabelView.clickCurrentSelectItem.selectItem = NO;
        [self recursionPreNoSelectTable:self.parentTabelView];
    }
}

///设置它所有的前级别全为选中状态
- (void)recursionPreNoSelectTable:(BTSelectLevelTableView *)tableView
{
    if (!wawa_objc_iskindClass_valid(tableView, [BTSelectLevelTableView class])) {
        return;
    }
    
    BOOL lastTableCotainSelectItem = [self containSelectItemForTableView:tableView];
    tableView.parentTabelView.clickCurrentSelectItem.selectItem = lastTableCotainSelectItem;
    [self recursionPreNoSelectTable:tableView.parentTabelView];
}

///判断当前tableView是否有选中的item
- (BOOL)containSelectItemForTableView:(BTSelectLevelTableView *)tableView
{
    NSArray <BTSelectLevelItemModel *>* items = tableView.dataListMArr.copy;
    __block BOOL containSelecItem = NO;
    [items enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) && obj.selectItem) {
            containSelecItem = YES; ///最后一级只要有一个选择就行
            *stop = YES;
        }
    }];
    
    return containSelecItem;
}

///设置它所有的前级别全为选中状态
- (void)recursionPreSelectTable:(BTSelectLevelTableView *)tableView
{
    if (!wawa_objc_iskindClass_valid(tableView, [BTSelectLevelTableView class])) {
        return;
    }
    
    tableView.clickCurrentSelectItem.selectItem = YES;
    [self recursionPreSelectTable:tableView.parentTabelView];
}

///把当前tableView后面的tableview的clickCurrentSelectItem=nil
- (void)processInvalidForPreTableViewsCilckItems:(NSMutableArray <BTSelectLevelTableView *>*)tables
{
    if (!wawa_marr_valid(tables)) {
        return;
    }
  
    NSArray <BTSelectLevelTableView *>*tableArr = tables.copy;
    [tableArr enumerateObjectsUsingBlock:^(BTSelectLevelTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelTableView class]) && idx > self.tableviewIndex) {
            obj.clickCurrentSelectItem = nil;
        }
    }];
}

///刷新单个cell
- (void)reloadRowForItemodel:(BTSelectLevelItemModel *)itemModel
{
    if (!wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class])) {
        return;
    }
    
    NSArray <BTSelectLevelItemModel *>* items = self.dataListMArr.copy;
    [items enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) && itemModel.ids == obj.ids) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

///删除所有选择（除了"全部"为选择）
- (void)removeAllAndUpdateAllItem_old:(NSMutableArray <BTSelectLevelItemModel *>*)resultMarr allItem:(BTSelectLevelItemModel *)allItem
{
    if (!wawa_marr_valid(resultMarr)) {
        return;
    }
    
    NSArray <BTSelectLevelItemModel *>* arr = self.dataListMArr.copy;
    [arr enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) &&
            ![BTSelctLevelViewManager isAllItemModel:obj] &&
            obj.selectItem) { ///非全部并且是在选择状态
            [self recursionRemoveAllAndUpdateAllItemChilds:resultMarr item:obj];
        }
    }];
    
    [self reloadData];
}

///删除所有选择（除了"全部"为选择）
- (void)removeAllAndUpdateAllItem:(NSMutableArray <BTSelectLevelItemModel *>*)resultMarr allItem:(BTSelectLevelItemModel *)allItem
{
    if (!wawa_marr_valid(resultMarr)) {
        return;
    }
    
    NSArray <BTSelectLevelItemModel *>* arr = self.dataListMArr.copy;
    [arr enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) &&
            ![BTSelctLevelViewManager isAllItemModel:obj] &&
            obj.selectItem) { ///非全部并且是在选择状态
            [self recursionRemoveAllAndUpdateAllItemChilds:resultMarr item:obj];
        }
    }];
    
    [self reloadData];
}

- (void)recursionRemoveAllAndUpdateAllItemChilds:(NSMutableArray <BTSelectLevelItemModel *>*)resultMarr item:(BTSelectLevelItemModel *)item
{
    if (!wawa_marr_valid(resultMarr) || !wawa_objc_iskindClass_valid(item, [BTSelectLevelItemModel class])) {
        return;
    }
    
    item.selectItem = NO;
    [item.childItemDataList enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) && obj.selectItem) {
            obj.selectItem = NO;
            [self removeItemForResultMarr:resultMarr item:obj];
        }
    }];
    
    [self removeItemForResultMarr:resultMarr item:item];
}

- (void)removeItemForResultMarr:(NSMutableArray <BTSelectLevelItemModel *>*)resultMarr item:(BTSelectLevelItemModel *)item
{
    if (!wawa_marr_valid(resultMarr)) {
        return;
    }
    
    NSArray <BTSelectLevelItemModel *>*resultArr = resultMarr.copy;
    [resultArr enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) && obj.ids == item.ids) {
            item.selectItem = NO;
            wawa_marr_removeObjectAtIndex(resultMarr, idx);
        }
    }];
}

///删除“全部”，其他动
- (void)removeAllItem:(NSMutableArray <BTSelectLevelItemModel *>*)resultMarr allItem:(BTSelectLevelItemModel *)allItem
{
    if (!wawa_marr_valid(resultMarr)) {
        return;
    }

    NSArray <BTSelectLevelItemModel *>* arr = self.dataListMArr.copy;
    [arr enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) &&
            [BTSelctLevelViewManager isAllItemModel:obj] &&
            obj.selectItem) { ///全部
            
            obj.selectItem = NO;
            [self removeItemForResultMarr:resultMarr item:obj];
            [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            *stop = YES;
        }
    }];
}

#pragma mark - ——————————————— Private Funcation ——————————————

#pragma mark - —————————————————— Touch Event  ————————————————

#pragma mark - ———————————————— Setter/Getter  ————————————————

- (NSMutableArray *)dataListMArr
{
    if (!_dataListMArr) {
        _dataListMArr = @[].mutableCopy;
    }
    
    return _dataListMArr;
}

@end
