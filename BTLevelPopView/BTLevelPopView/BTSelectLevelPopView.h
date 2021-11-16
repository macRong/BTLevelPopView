//
//  BTSelectLevelPopView.h
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

@interface BTSelectLevelPopView : UIView

@property (nonatomic, assign) CGFloat popViewHeight;  ///default：整个屏幕高*0.7
@property (nonatomic, strong) BTSelectLevelModel *dataModel; ///多级数据


///确认回调 modes:选择后所有的models,
@property (nonatomic, copy) void(^confirmSelectItemsBlock)(NSArray <BTSelectLevelItemModel *>* modes, BTSelectLevelModel *dataModel);

+ (instancetype)popView;
- (void)show;

@end

NS_ASSUME_NONNULL_END


/** 例子
 
 
 - (void)showLevelViewWishCity:(NSArray<BTSelectLevelItemModel *> *)models
 {
     BTSelectLevelPopView *popView = [BTSelectLevelPopView popView];
     BTSelectLevelModel *model = [BTSelectLevelModel new];
     model.maxlimitCount = [BTJYQInitManager sharedInstance].model.wishCityNum;
     model.maxlimitMsg = [NSString stringWithFormat:@"最多可选择%ld个工作城市",(long)model.maxlimitCount];
     model.minlimitMsg = [NSString stringWithFormat:@"至少选择1个工作城市"];
     model.title = @"选择工作城市";
     model.des = [NSString stringWithFormat:@"（最多可选择%ld个城市）",(long)model.maxlimitCount];
     model.dataList = models;
     
     ///高亮赋值
     BTJYQIssueCellModel *cellModel = [self.viewModel cellModelWithCellModelType:BTJYQFindWorkCellModelType_wishCity];
     ///高亮数据 @{1:[item1] ,2: [item3,item4]}
     if (wawa_mdic_valid_containEmptyDic(cellModel.hightDataSource)) {
         model.selectDataListMdic = cellModel.hightDataSource;
     }else {
         model.selectDataListMdic = @{}.mutableCopy;
     }
     ///选择后的result数据 @[item1, item2]
     if(wawa_arr_valid(cellModel.flagDataSource)) {
         model.selectArr = cellModel.flagDataSource;
     }
     
     popView.dataModel = model;
     [popView show];
     
     __weak typeof(self) weakSelf = self;
     popView.confirmSelectItemsBlock = ^(NSArray<BTSelectLevelItemModel *> * _Nonnull modes, BTSelectLevelModel *dataModel) {
         BTJYQIssueCellModel *cityCellModel = [weakSelf.viewModel cellModelWithCellModelType:BTJYQFindWorkCellModelType_wishCity];
         cityCellModel.flagDataSource = modes; ///高亮
         cityCellModel.hightDataSource = dataModel.selectDataListMdic;///高亮
         BTJYQSelectWorkerModel *workModel = cityCellModel.dataSource;
         workModel.content = [weakSelf.viewModel wishCityContentWith:modes];
         NSMutableArray <BTJYQItemAddressModel *> *itemModelMarr = workModel.datasource;
         if(wawa_marr_valid(itemModelMarr)) [itemModelMarr removeAllObjects];
         wawa_marr_addValidArray(itemModelMarr, [weakSelf.viewModel coderModel:modes]);
         [weakSelf.tableView reloadData];
     };
 }
 
 
 */
