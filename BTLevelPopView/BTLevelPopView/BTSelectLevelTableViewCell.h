//
//  BTSelectLevelTableViewCell.h
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import <UIKit/UIKit.h>
#import "BTSelectLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTSelectLevelTableViewCell : UITableViewCell

+ (instancetype)tableViewCellTableView:(UITableView *)tableView;

- (void)loadDataWithItemModel:(BTSelectLevelItemModel *)itemModel;
///点击
- (void)clickCellLoadData:(BTSelectLevelItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
