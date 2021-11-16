//
//  BTSelectLevelModel.h
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import <Foundation/Foundation.h>
@class BTSelectLevelItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTSelectLevelModel : NSObject

@property (nonatomic, copy) NSString *title; ///如：选择城市
@property (nonatomic, copy) NSString *des;   ///如：（最多选择xx城市）
@property (nonatomic, assign) NSInteger maxlimitCount; ///选择的最大数量  default 0:不限 (如果要单选设置为：1)
@property (nonatomic, assign) NSInteger minlimitCount; ///选择的最小数量  default ：1
@property (nonatomic, copy) NSString *maxlimitMsg; ///选择的最大数量的提示msg
@property (nonatomic, copy) NSString *minlimitMsg; ///选择的最小数量的提示msg
@property (nonatomic, assign) BOOL autoOpenHightItems; ///默认：YES刚进来时自动展开高亮数据（不管单选多选，只取高亮第一级第一个元素）

@property (nonatomic, strong) NSArray <BTSelectLevelItemModel *> *dataList; ///数据源
///生成的选中并分类级别后的数据

///----自定义 ----
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSMutableArray <BTSelectLevelItemModel *>*> *selectDataListMdic;///选择后的高亮数据
@property (nonatomic, strong) NSArray<BTSelectLevelItemModel *> *selectArr;///选择后的result数据

@end

@interface BTSelectLevelItemModel : NSObject

@property (nonatomic, assign) BOOL selectItem;     ///item是否选中
@property (nonatomic, copy) NSString *itemContent; ///item内容
@property (nonatomic, assign) NSInteger level;     ///item是第几级 (接口返回的，城市有，其他可能是0)
@property (nonatomic, assign) NSInteger selectItemLevel;     ///选择后的，item是第几级
@property (nonatomic, assign) NSInteger ids;     ///item分类ID
@property (nonatomic, assign) NSInteger pid;     ///item分类上级ID
@property (nonatomic, copy) NSString *iocPath;   ///可选（图标）
@property (nonatomic, assign) NSInteger all;     ///1=默认值 2=全部 ( "全部"选项)
@property (nonatomic, assign) NSInteger allID;  ///自定义，每个allID不一样(用于区分不同级"全部")

@property (nonatomic, strong) BTSelectLevelItemModel *parentItemModel; ///上一级
@property (nonatomic, strong) NSArray <BTSelectLevelItemModel *> *childItemDataList; ///下一级
@property (nonatomic, strong) id originDataSource; ///item源数据（只做引用绑定不做任何处理）

@end

NS_ASSUME_NONNULL_END
