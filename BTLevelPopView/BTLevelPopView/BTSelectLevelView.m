//
//  BTSelectLevelView.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "BTSelectLevelView.h"
#import "BTSelectLevelTableView.h"
#import "BTSelectLevelTableViewCell.h"
#import "BTSelctLevelViewManager.h"
#import <Masonry/Masonry.h>
#import "UIView+InsideToast.h"

#define KBF_is_iPhoneX_Type  \
({\
    BOOL isYes = NO;\
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) {\
        CGSize size = [UIScreen mainScreen].bounds.size;\
        NSInteger notchValue = size.width / size.height * 100;\
        if (216 == notchValue || 46 == notchValue) {\
            isYes = YES;\
        }\
    }\
    (isYes);\
})

/*底部安全区域间隙*/
#define h_BottomSafeMargin (CGFloat)(KBF_is_iPhoneX_Type?(34.0):(20))

@interface BTSelectLevelView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *confirmButton; ///确认按钮
@property (nonatomic, strong) NSMutableArray <BTSelectLevelTableView *>*tables;
@property (nonatomic, strong) BTSelctLevelViewManager *manager;
@property (nonatomic, assign) int tableviewIndex; ///第几个tableview defatul:0
@property (nonatomic, strong) NSMutableArray <BTSelectLevelItemModel *>* resultMarr; ///数据源

@end

@implementation BTSelectLevelView

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
    _tableviewIndex = 0;
    _tables = @[].mutableCopy;
    _resultMarr = @[].mutableCopy;
}

/** 创建相关子view */
- (void)initViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    ///tableview
    BTSelectLevelTableView *firstTableView = [self createTableView];
    [self addSubview:firstTableView];
    [self.tables addObject:firstTableView];
    firstTableView.visibleTableView = YES;
    [firstTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self).inset(0);
    }];
    
    ///确认-btn
    [self addSubview:self.confirmButton];
    [self bringSubviewToFront:self.confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(22.5);
        make.height.mas_equalTo(42);
        make.bottom.mas_equalTo(self).inset(h_BottomSafeMargin);
    }];
}

- (BTSelectLevelTableView *)firstTableView
{
    BTSelectLevelTableView *tableView = (BTSelectLevelTableView *)self.tables[0];
    return tableView;
}

#pragma mark - ——————————————— Public Funcation ———————————————

- (void)setDataList:(NSArray <BTSelectLevelItemModel *>*)dataList
{
    _dataList = dataList;
    
    BTSelectLevelTableView *tableView = [self firstTableView];
    tableView.dataListMArr = dataList.mutableCopy;

    ///把高亮数据先赋值给resultMarr
    [self.manager processSelectHightResultMarr:self.resultMarr selectDataModel:self.dataModel];

    ///查看是否有高亮数据，如果有就赋值
    [self.manager processSelectHightItemModels:tableView.dataListMArr
                                         index:tableView.tableviewIndex
                               selectDataModel:self.dataModel];
    
    [tableView reloadData];

    ///自动展开选中的items
    if (self.dataModel.autoOpenHightItems) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self recursionAutoShowSelectTableView:tableView];
        });
    }
}

#pragma mark - 自动展开选中tableviews

- (void)recursionAutoShowSelectTableView:(BTSelectLevelTableView *)tableView
{
    if (!wawa_objc_iskindClass_valid(tableView, [BTSelectLevelTableView class])) {
        return;
    }
    
    NSIndexPath *indexPath = [self indexPathForTableView:tableView];
    if (!indexPath || indexPath.row < 0) {
        return;
    }

    [self autoSelectTableView:tableView didSelectRowAtIndexPath:indexPath autoSelect:YES];
    
    ///递归查询下一级
    dispatch_async(dispatch_get_main_queue(), ^{
        [self recursionAutoShowSelectTableView:self.tables[tableView.tableviewIndex+1]];
    });
}

- (NSIndexPath *)indexPathForTableView:(BTSelectLevelTableView *)tableView
{
    if (!wawa_objc_iskindClass_valid(tableView, [BTSelectLevelTableView class])) {
        return nil;
    }
    
    NSInteger selectIndex = [self firstItemIndexForTableHight:tableView];
    ///当前级别中有选中的item
    if (selectIndex < 0) {
        return nil;
    }

    NSInteger scrTopRow = selectIndex > 3 ? selectIndex -3 : selectIndex;
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrTopRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    return [NSIndexPath indexPathForRow:selectIndex inSection:0];
}

- (void)indexPathForSelectSelectTableView:(BTSelectLevelTableView *)tableView
{
    NSIndexPath *indexPath = [self indexPathForTableView:tableView];
    if (!indexPath || indexPath.row < 0) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

///获取tableview的第一个选中的index
- (NSInteger)firstItemIndexForTableHight:(BTSelectLevelTableView *)tableView
{
    if (!wawa_objc_iskindClass_valid(tableView, [BTSelectLevelTableView class]) ||
        !wawa_marr_valid(tableView.dataListMArr)) {
        return -1;
    }
    
    __block NSInteger result = -1;
    [tableView.dataListMArr enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) && obj.selectItem) { ///第一个选中转台就行
            result = idx;
//            tableView.clickCurrentSelectItem = obj; // ??
            *stop = YES;
        }
    }];
    
    return result;
}

#pragma mark - —————————————————— Delegate Event  ————————————————

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BTSelectLevelTableView *selectTableView = (BTSelectLevelTableView *)tableView;
    return selectTableView.dataListMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTSelectLevelTableViewCell *cell = [BTSelectLevelTableViewCell tableViewCellTableView:tableView];
    BTSelectLevelTableView *selectTableView = (BTSelectLevelTableView *)tableView;
    [cell loadDataWithItemModel:wawa_arr_getValidObject(selectTableView.dataListMArr, indexPath.row)];

    return cell ? :[UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self autoSelectTableView:tableView didSelectRowAtIndexPath:indexPath autoSelect:NO];
}

- (void)autoSelectTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath autoSelect:(BOOL)autoSelect
{
    BTSelectLevelTableViewCell *cell = (BTSelectLevelTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    BTSelectLevelTableView *selectTableView = (BTSelectLevelTableView *)tableView;
    BTSelectLevelItemModel *itemModel = selectTableView.dataListMArr[indexPath.row];
    if (wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class])) {
        if (wawa_arr_valid(itemModel.childItemDataList)) { ///展开 (还有下一级)
            ///非最后一级，如果没有选中或者它的下一级隐藏了就走下面
            if (selectTableView.clickCurrentSelectItem != itemModel) {
                [selectTableView removeAllItem:self.resultMarr allItem:itemModel]; ///检测是否选择了“全部”

                ///刷新当前tableivew的上一个cell
                [selectTableView reloadRowForItemodel:selectTableView.clickCurrentSelectItem];
                [selectTableView processInvalidForPreTableViewsCilckItems:self.tables]; ///tableview后面clickCurrentSelectItem=nil
                selectTableView.clickCurrentSelectItem = itemModel;
                BTSelectLevelTableView *nextTable = [self nextTableViewWithSelctTableView:selectTableView indexPath:indexPath];
                [self reloadNewTableAndLayoutAllTableViews:nextTable];
            }
        }else { ///最后一级了，点击可以多选
            if (autoSelect) {  ///auto自动扩展来的，最后一级不做处理
                return;
            }
            [self checkAndProcessLastTableView:selectTableView];  ///如果没有下一级，把上一次的下一级收回去
            if ([BTSelctLevelViewManager isAllItemModel:itemModel]) { ///全部 (要互斥,主要不要全选下面的，因为有数量限制)
                [selectTableView removeAllAndUpdateAllItem:self.resultMarr allItem:itemModel];
            }else {
                [selectTableView removeAllItem:self.resultMarr allItem:itemModel];
            }
            
            ///限制最大数量
            if ([self processLimitHint:selectTableView itemModel:itemModel cell:cell indexPath:indexPath]) {
                return;
            }
            
            [cell clickCellLoadData:itemModel];
            [self processLastMultipleItem:itemModel tableView:selectTableView];
            [selectTableView updatePreTableViewSeletStatus];
            [selectTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)processLastMultipleItem:(BTSelectLevelItemModel *)item tableView:(BTSelectLevelTableView *)tableView
{
    if (!wawa_objc_iskindClass_valid(item, [BTSelectLevelItemModel class])) {
        return;
    }
    
    [self recursionItem:item tableView:tableView]; ///赋值上一级的

    if (item.selectItem) { ///选中
        [self.manager addSelectForSelectArrWith:item dataModel:self.dataModel];
        [self.manager addSelectItem:item itemMarr:self.resultMarr];
    }else { ///取消
        [self.manager removeSelectItem:item itemMarr:self.resultMarr];
        [self.manager removeSelectForSelectArrWith:item dataModel:self.dataModel];
    }
}

///为选中的Item赋值级别
- (void)processItemLevel:(BTSelectLevelItemModel *)item tableView:(BTSelectLevelTableView *)tableView
{
    if (!wawa_objc_iskindClass_valid(tableView, [BTSelectLevelTableView class])) {
        return;
    }
    
    item.selectItemLevel = [self.tables indexOfObject:tableView];
}

///递归赋值上级Item
- (void)recursionItem:(BTSelectLevelItemModel *)item tableView:(BTSelectLevelTableView *)tableView
{
    if (!wawa_objc_iskindClass_valid(tableView, [BTSelectLevelTableView class])) {
        return;
    }
    
    [self processItemLevel:item tableView:tableView]; ///为选中的Item赋值级别
    if (wawa_objc_iskindClass_valid(tableView.parentTabelView, [BTSelectLevelTableView class]) && item) {
        item.parentItemModel = tableView.parentTabelView.clickCurrentSelectItem;
    }
    
    [self recursionItem:item.parentItemModel tableView:tableView.parentTabelView];
}

///限制最大数量
- (BOOL)processLimitHint:(BTSelectLevelTableView *)selectTableView
               itemModel:(BTSelectLevelItemModel *)itemModel
                    cell:(BTSelectLevelTableViewCell *)cell
               indexPath:(NSIndexPath *)indexPath
{
    if (!itemModel.selectItem && self.resultMarr.count+1 > self.dataModel.maxlimitCount) {
        [self showInsideToastMessage:self.dataModel.maxlimitMsg];
        itemModel.selectItem = YES; ///这里为了点击高亮后还原
        [cell clickCellLoadData:itemModel];
        [selectTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return YES;
    }
    
    return NO;
}

///还原之前的多级Tableview状态(之前是3级，现在可能是2级，还原第3级的tableview)
- (void)checkAndProcessLastTableView:(BTSelectLevelTableView *)tableView
{
    NSArray <BTSelectLevelTableView *>*allTables = self.tables.copy; ///获取visibletables
    [allTables enumerateObjectsUsingBlock:^(BTSelectLevelTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelTableView class]) &&
            obj.visibleTableView &&
            idx >= tableView.tableviewIndex+1) {
            [self layouAllTables:tableView];
            obj.visibleTableView = NO;
        }
    }];
}

#pragma mark - ——————————————— Private Funcation ——————————————

- (void)reloadNewTableAndLayoutAllTableViews:(BTSelectLevelTableView *)newTable
{
    if (!newTable.visibleTableView && ![self.subviews containsObject:newTable]) {
        newTable.visibleTableView = YES;
        [self insertSubview:newTable belowSubview:self.confirmButton];
        [newTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self);
            make.width.mas_equalTo(0);
            make.left.mas_equalTo(self.mas_left).inset(-[UIScreen mainScreen].bounds.size.width);
        }];
    }

    ///查看是否有高亮数据，如果有就赋值
    [self.manager processSelectHightItemModels:newTable.dataListMArr
                                         index:newTable.tableviewIndex
                                     selectDataModel:self.dataModel];

    [newTable reloadData];

    [self layouAllTables:newTable];
    
    ///定位row的位置（尽量定位中间位置）
    [self indexPathForSelectSelectTableView:newTable];
}

///重新布局所有的tables
- (void)layouAllTables:(BTSelectLevelTableView *)newTable
{
    NSArray <BTSelectLevelTableView *>*allTables = self.tables.copy; ///获取visibletables
    CGFloat everyTableViewWidth = [UIScreen mainScreen].bounds.size.width/(newTable.tableviewIndex+1);
    for (int i = 0; i < allTables.count; i ++) {
        BTSelectLevelTableView *tableView = allTables[i];
        if (!wawa_objc_iskindClass_valid(tableView, [BTSelectLevelTableView class])) {
            continue;
        }
        
        if (i == 0) { ///第一个table
            [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self).inset([UIScreen mainScreen].bounds.size.width- everyTableViewWidth);
            }];
        }else {
            CGFloat tableWidth = i <= newTable.tableviewIndex ? everyTableViewWidth: 0;
            CGFloat tableLeftSpec = i <= newTable.tableviewIndex ? i*everyTableViewWidth: [UIScreen mainScreen].bounds.size.width;
            tableView.visibleTableView = i <= newTable.tableviewIndex;
            
            [UIView animateWithDuration:0.2 animations:^{
                [tableView.superview layoutIfNeeded];
                
                [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(tableWidth);
                    make.left.mas_equalTo(self.mas_left).inset(tableLeftSpec);
                }];
            }];
        }
    }
}

///获取上一级tableView
- (BTSelectLevelTableView *)preTablew:(BTSelectLevelTableView *)tableView
{
    NSArray <BTSelectLevelTableView *>*allTables = self.tables.copy;
    NSUInteger selectTableIndex = [allTables indexOfObject:tableView];
    BTSelectLevelTableView *preTableView = wawa_arr_getValidObject(allTables, selectTableIndex-1);
    return preTableView;
}

///获取下一级tableView(懒加载方式)
- (BTSelectLevelTableView *)nextTableViewWithSelctTableView:(BTSelectLevelTableView *)selectTableView indexPath:(NSIndexPath *)indexPath
{
    NSArray <BTSelectLevelTableView *>*allTables = self.tables.copy;
    NSUInteger selectTableIndex = [allTables indexOfObject:selectTableView];
    BTSelectLevelItemModel *itemModel = selectTableView.dataListMArr[indexPath.row];
    BTSelectLevelTableView *tableView = nil;
    if (selectTableIndex+1 < allTables.count) { ///池子中有待用的tableview
        tableView = allTables[selectTableIndex+1];
    }else { ///池子中没有多余的tableview了
        tableView = [self createTableView];
        tableView.parentTabelView = selectTableView;
        [self.tables addObject:tableView];
    }
    
    if(wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class])) {
        tableView.dataListMArr = itemModel.childItemDataList.mutableCopy;
    }
    
    return tableView;
}

#pragma mark - —————————————————— Touch Event  ————————————————

- (void)confirmAction:(UIButton *)btn
{
    if (self.confirmSelectItemsBlock) {
        self.confirmSelectItemsBlock(self.resultMarr.copy, self.dataModel);
    }
}

#pragma mark - ———————————————— Setter/Getter  ————————————————

- (BTSelectLevelTableView *)createTableView
{
    BTSelectLevelTableView *tableView = [BTSelectLevelTableView new];
    tableView.tableviewIndex = self.tableviewIndex++;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    UIEdgeInsets inset = tableView.contentInset;
    inset.bottom = 70;
    tableView.contentInset = inset;
    tableView.backgroundColor = [self.manager tableLevelColor:self.tables.copy];
    
    return tableView;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.backgroundColor = colorFromRGB(0x0A7EFC);
        confirmButton.layer.cornerRadius = 4;
        confirmButton.layer.masksToBounds = YES;
        confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [confirmButton setTitleColor:colorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton = confirmButton;
    }
    
    return _confirmButton;
}

- (BTSelctLevelViewManager *)manager
{
    if (!_manager) {
        _manager = [BTSelctLevelViewManager new];
    }
    
    return _manager;
}

static UIColor* colorFromRGB(long rbg)
{
    return [UIColor colorWithRed:((float)((rbg & 0xFF0000) >> 16))/255.0 green:((float)((rbg & 0xFF00) >> 8))/255.0 blue:((float)(rbg & 0xFF))/255.0 alpha:1.0];
}

@end
