//
//  BTSelectLevelModel.m
//  BTLevelPopView
//
//  Created by macRong on 2021/11/16.
//

#import "BTSelectLevelModel.h"

@implementation BTSelectLevelModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _minlimitCount = 1;
        _autoOpenHightItems = YES;
    }
    
    return self;
}

- (NSMutableDictionary<NSNumber *,NSMutableArray<BTSelectLevelItemModel *> *> *)selectDataListMdic
{
    if (!_selectDataListMdic) {
        _selectDataListMdic = @{}.mutableCopy;
    }
    
    return _selectDataListMdic;
}

- (NSString *)maxlimitMsg
{
    if (!_maxlimitMsg) {
        return @"超过最大选择限制";
    }
    
    return _maxlimitMsg;
}

- (NSString *)minlimitMsg
{
    if (!_minlimitMsg) {
        return @"至少选择一个";
    }
    
    return _minlimitMsg;
}

@end


@implementation BTSelectLevelItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ids" : @"id"};
}
@end
