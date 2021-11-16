//
//  BTSelctLevelViewManager.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "BTSelctLevelViewManager.h"
#import "BTSelectLevelModel.h"

///最大级别 （>20级肯定不存在）
static NSInteger g_levelView_levelMax = 20;

@implementation BTSelctLevelViewManager

#pragma mark - 不同级别table的gbcolor

- (UIColor *)tableLevelColor:(NSArray *)arr
{
    NSArray<UIColor *>* colors = [self tableViewColors];
    if (!wawa_arr_valid(arr)) {
        return colors[0];
    }
    
    if (arr.count == 1) {
        return colors[1];
    }
    
    return colors[2];
}

- (NSArray<UIColor *>*)tableViewColors
{
    NSArray *colors = @[[UIColor whiteColor],colorFromRGB(0xF5F5F5) ,colorFromRGB(0xE6E6E6)];
    return colors;
}

#pragma mark -高亮逻辑

///把选中item放入对应分类arr中
- (void)addSelectForSelectArrWith:(BTSelectLevelItemModel *)itemModel dataModel:(BTSelectLevelModel *)dataModel
{
    if (!wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class]) ||
        !wawa_objc_iskindClass_valid(dataModel, [BTSelectLevelModel class])) {
        return;
    }
        
    [self recursionMarrWithIndex:itemModel dataModel:dataModel];
}

- (void)recursionMarrWithIndex:(BTSelectLevelItemModel *)itemModel
                     dataModel:(BTSelectLevelModel *)dataModel
{
    if (!wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class])) {
        return;
    }
    
    NSMutableDictionary <NSNumber *, NSMutableArray <BTSelectLevelItemModel *>*> *mdic = dataModel.selectDataListMdic;
    if (!mdic || !wawa_objc_iskindClass_valid(mdic, [NSMutableDictionary class])) {
        dataModel.selectDataListMdic = @{}.mutableCopy;
        mdic = dataModel.selectDataListMdic;
    }
        
    NSMutableArray <BTSelectLevelItemModel *>*itemMarr = mdic[@(itemModel.selectItemLevel)];
    if (!itemMarr || !wawa_marr_valid_containEmptyArray(itemMarr)) {
        itemMarr = @[].mutableCopy;
        wawa_mdic_setValidObject(mdic, @(itemModel.selectItemLevel), itemMarr);
    }
    
    BTSelectLevelItemModel *parent = itemModel.parentItemModel;

    ///同级下 ”全部“和非全部是互斥的，选择全部要把非全部全删除
    if ([[self class] isAllItemModel:itemModel]) {
        [parent.childItemDataList enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class])) {
                [self removeSelectItem:obj itemMarr:itemMarr];
            }
        }];
    }else { ///把”全部“删除
        [parent.childItemDataList enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[self class] isAllItemModel:obj]) {
                [self removeSelectItem:obj itemMarr:itemMarr];
            }
        }];
    }
    
    [self addSelectItem:itemModel itemMarr:itemMarr];
    
    [self recursionMarrWithIndex:itemModel.parentItemModel dataModel:dataModel];
}

///把选中item在对应分类arr中删除
- (void)removeSelectForSelectArrWith:(BTSelectLevelItemModel *)itemModel dataModel:(BTSelectLevelModel *)dataModel
{
    if (!wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class]) ||
        !wawa_objc_iskindClass_valid(dataModel, [BTSelectLevelModel class])) {
        return;
    }
    
    [self recursionDeleteMarrWithIndex:itemModel dataModel:dataModel predelete:YES];
}

- (void)recursionDeleteMarrWithIndex:(BTSelectLevelItemModel *)itemModel
                     dataModel:(BTSelectLevelModel *)dataModel
                     predelete:(BOOL)predelete
{
    if (!wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class])) {
        return;
    }
    
    NSMutableDictionary <NSNumber *, NSMutableArray <BTSelectLevelItemModel *>*> *mdic = dataModel.selectDataListMdic;
    if (!mdic || !wawa_objc_iskindClass_valid(mdic, [NSMutableDictionary class])) {
        return;
    }
        
    NSMutableArray <BTSelectLevelItemModel *>*itemMarr = mdic[@(itemModel.selectItemLevel)];
    if (!wawa_marr_valid(itemMarr)) {
        return;
    }
    
    if (predelete) {
        BOOL deleteSuccess = [self removeSelectItem:itemModel itemMarr:itemMarr];
        if (deleteSuccess) {
            itemModel.selectItem = NO;
            predelete = ![self containSelectSameLevel:itemModel.parentItemModel]; ///同级如果还有选中的，那么上级就不删除
            if (!predelete) {
                return;
            }
        }
    }
    
    [self recursionDeleteMarrWithIndex:itemModel.parentItemModel dataModel:dataModel predelete:predelete];
}

///同一级是否有选中的item
- (BOOL)containSelectSameLevel:(BTSelectLevelItemModel *)preItemModel
{
    if (!wawa_objc_iskindClass_valid(preItemModel, [BTSelectLevelItemModel class])) {
        return NO;
    }
    
    NSArray <BTSelectLevelItemModel *> *childItemDataList = preItemModel.childItemDataList;
    if (!wawa_arr_valid(childItemDataList)) {
        return NO;
    }
    
    __block BOOL result = NO;
    [childItemDataList enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class]) && obj.selectItem) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

///把高亮result数据赋值给resultMarr
- (void)processSelectHightResultMarr:(NSMutableArray<BTSelectLevelItemModel *> *)resultMarr
                     selectDataModel:(BTSelectLevelModel *)selectDataModel
{
    if (!wawa_objc_iskindClass_valid(selectDataModel, [BTSelectLevelModel class])) {
        return;
    }
    
    NSArray<BTSelectLevelItemModel *> *selectResultarr = selectDataModel.selectArr;
    if (!wawa_arr_valid(selectResultarr)) {
        return;
    }

    wawa_marr_addValidArray(resultMarr, selectResultarr);
}

- (void)processSelectHightItemModels:(NSArray <BTSelectLevelItemModel *>*)dataList
                               index:(NSInteger)index
                     selectDataModel:(BTSelectLevelModel *)selectDataModel
{
    if (!wawa_objc_iskindClass_valid(selectDataModel, [BTSelectLevelModel class])) {
        return;
    }
    
    NSMutableDictionary <NSNumber *, NSMutableArray <BTSelectLevelItemModel *>*> *selectMDic = selectDataModel.selectDataListMdic;
    
    if (!wawa_arr_valid(dataList) ||
        (index < 0 || index > g_levelView_levelMax) ||
        !wawa_mdic_valid(selectMDic)) {
        return;
    }
    
    NSMutableArray <BTSelectLevelItemModel *> *marr = selectMDic[@(index)];
    if (!wawa_marr_valid(marr)) {
        return;
    }
    
    [dataList enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class])) {
           
                BOOL contain = [self containItem:obj marr:marr];
                if (contain && !obj.selectItem) {
                        obj.selectItem = YES;

                    ///（把返回出去的result也赋值 ：processSelectHightResultMarr:函数已经赋值给resultMarr）
                    [self addSelectForSelectArrWith:obj dataModel:selectDataModel];
                }
        }
    }];
}

///marr是否包含itemmodel（必须根据ids，不能是对象）(如果是“全部”，ids都是一样的要区分下)
- (BOOL)containItem:(BTSelectLevelItemModel *)itemModel marr:(NSMutableArray <BTSelectLevelItemModel *> *)marr
{
    if (!wawa_marr_valid(marr) ||
        !wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class])) {
        return NO;
    }
    
    __block BOOL result = NO;
    [marr enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wawa_objc_iskindClass_valid(obj, [BTSelectLevelItemModel class])) {
            if ([self sameItem:itemModel otherItem:obj]) {
                result = YES;
                *stop = YES;
            }
        }
    }];
    
    return result;
}

- (void)addSelectItem:(BTSelectLevelItemModel *)item itemMarr:(NSMutableArray <BTSelectLevelItemModel *>*)itemMarr
{
    if (!wawa_objc_iskindClass_valid(item, [BTSelectLevelItemModel class]) ||
        !wawa_marr_valid_containEmptyArray(itemMarr)) {
        return;
    }
  
    ///不包含在加入进来
    if (![self containItem:item marr:itemMarr]) {
        [itemMarr addObject:item];
    }
}

///数组中删除对应的ItemoModel（根据ids，不能是object）
- (BOOL)removeSelectItem:(BTSelectLevelItemModel *)item
                itemMarr:(NSMutableArray <BTSelectLevelItemModel *>*)itemMarr
{
    if (!wawa_objc_iskindClass_valid(item, [BTSelectLevelItemModel class]) ||
        !wawa_marr_valid(itemMarr)) {
        return NO;
    }
    
    __block BOOL result = NO;
    [itemMarr enumerateObjectsUsingBlock:^(BTSelectLevelItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self sameItem:item otherItem:obj]) {
            wawa_marr_removeObjectAtIndex(itemMarr, idx);
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

///判断2个ItemModel是否相同
- (BOOL)sameItem:(BTSelectLevelItemModel *)item otherItem:(BTSelectLevelItemModel *)otherItem
{
    if (!wawa_objc_iskindClass_valid(item, [BTSelectLevelItemModel class]) ||
        !wawa_objc_iskindClass_valid(otherItem, [BTSelectLevelItemModel class])) {
            return NO;
        }

    ///如果两个都是“全部“ 再去判断他们的pid是否相同
    if ([[self class] isAllItemModel:item] &&
        [[self class] isAllItemModel:otherItem]) {
        return item.pid == otherItem.pid;
    }
    
    return (item.ids == otherItem.ids);
}

#pragma mark - “全部”判断逻辑

///item是否是“全部”item
+ (BOOL)isAllItemModel:(BTSelectLevelItemModel *)itemModel
{
    if (!wawa_objc_iskindClass_valid(itemModel, [BTSelectLevelItemModel class])) {
        return NO;
    }

    return (itemModel.all == [[self class] allItemID]);
}

///获取“全部” all : 1=默认值 2=全部
+ (NSInteger)allItemID
{
    return 2;
}

UIColor* colorFromRGB(long rbg)
{
    return [UIColor colorWithRed:((float)((rbg & 0xFF0000) >> 16))/255.0 green:((float)((rbg & 0xFF00) >> 8))/255.0 blue:((float)(rbg & 0xFF))/255.0 alpha:1.0];
}

@end
