//
//  CircleTableViewCell.h
//  TTLinkLabel
//
//  Created by hubin on 18/01/2021.
//
/**
 这里仅仅只是图文的 实际上应该还有视频 链接等等
 */

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"
#import "CircleModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CircleCellClickType) {
    CircleCellClickText = 0,//点击文本内容
    CircleCellClickLoction,//点击定位
    CircleCellClickUserName//点击点赞人名
};

@protocol CircleTableViewCellDelegate <NSObject>

@optional
- (void) deleteCurrentCircle:(CircleModel *)model;

- (void) commentCurrentCircle:(CircleModel *)model extraData:(id)extraData;

- (void) likeCurrentCircle:(CircleModel *)model;

- (void) didClickLink:(MLLink*)link linkText:(NSString*)linkText clickType:(CircleCellClickType)clickType;

- (void) didClickImageItem:(NSInteger)index imageViews:(NSArray *)imageViews;

@end

@interface CircleTableViewCell : UITableViewCell

@property (nonatomic , strong) CircleModel * model;

@property (nonatomic , copy) void(^refreshCellUI)(bool isExpand);

@property (nonatomic , weak) id<CircleTableViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
