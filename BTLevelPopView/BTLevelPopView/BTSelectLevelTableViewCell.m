//
//  BTSelectLevelTableViewCell.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "BTSelectLevelTableViewCell.h"
#import "BTSelectLevelTableView.h"
#import <Masonry/Masonry.h>

@interface BTSelectLevelTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *bgSelectImageView;
@property (nonatomic, weak) BTSelectLevelTableView *tableView;

@end

@implementation BTSelectLevelTableViewCell
#pragma mark - ——————————————————— LifeCycle ——————————————————

- (void)dealloc
{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initVars];
        [self initViews];
        
    }
    return self;
}

+ (instancetype)tableViewCellTableView:(UITableView *)tableView
{
    BTSelectLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    if (!cell) {
        cell = [[BTSelectLevelTableViewCell alloc] initWithStyle:0 reuseIdentifier:NSStringFromClass(self.class)];
    }
    
    cell.backgroundColor = [UIColor clearColor];

    BTSelectLevelTableView *table = (BTSelectLevelTableView *)tableView;
    cell.tableView = table;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = (table.tableviewIndex - 1) >= 1 ? nil : colorFromRGB(0xEAEAEA); ///UIColorFromRGB(0xF2F3F4)
    cell.selectedBackgroundView = imageView;
    cell.multipleSelectionBackgroundView = imageView;
    cell.nameLabel.highlightedTextColor = colorFromRGB(0x0A7EFC);

    return cell;
}

/** 初始化变量 */
- (void)initVars
{
    
}

/** 创建相关子view */
- (void)initViews
{
    [self.contentView addSubview:self.nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView).inset(10);
        make.left.right.mas_equalTo(self.contentView).inset(15);
    }];
}

#pragma mark - ——————————————— Public Funcation ———————————————

- (void)loadDataWithItemModel:(BTSelectLevelItemModel *)itemModel
{
    BOOL selectCell = itemModel.selectItem;
    self.nameLabel.text = itemModel.itemContent;
    self.nameLabel.textColor =  selectCell ? colorFromRGB(0x0A7EFC) : colorFromRGB(0x000000);
}

- (void)clickCellLoadData:(BTSelectLevelItemModel *)itemModel
{
    itemModel.selectItem = !itemModel.selectItem;
    self.nameLabel.textColor =  itemModel.selectItem ? colorFromRGB(0x0A7EFC) : colorFromRGB(0x000000);
}

#pragma mark - ——————————————— Private Funcation ——————————————

#pragma mark - —————————————————— Touch Event  ————————————————

#pragma mark - ———————————————— Setter/Getter  ————————————————

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textColor = colorFromRGB(0x000000);
    }
    
    return _nameLabel;
}

- (UIImageView *)bgSelectImageView
{
    if (!_bgSelectImageView) {
        _bgSelectImageView = [[UIImageView alloc]init];
    }
    
    return _bgSelectImageView;
}

static UIColor* colorFromRGB(long rbg)
{
    return [UIColor colorWithRed:((float)((rbg & 0xFF0000) >> 16))/255.0 green:((float)((rbg & 0xFF00) >> 8))/255.0 blue:((float)(rbg & 0xFF))/255.0 alpha:1.0];
}

@end
