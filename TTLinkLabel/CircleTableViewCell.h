//
//  CircleTableViewCell.h
//  TTLinkLabel
//
//  Created by Mr.Zhu on 18/01/2021.
//

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"
#import "CircleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CircleTableViewCellDelegate <NSObject>

@optional
- (void) deleteCurrentCircle:(CircleModel *)model;

- (void) commentCurrentCircle:(CircleModel *)model;

- (void) likeCurrentCircle:(CircleModel *)model;

- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel;

@end

@interface CircleTableViewCell : UITableViewCell

@property (nonatomic , strong) CircleModel * model;

@property (nonatomic , copy) void(^refreshCellUI)(bool isExpand);

@property (nonatomic , weak) id<CircleTableViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
