//
//  CommentTableViewCell.h
//  TTLinkLabel
//
//  Created by hubin on 25/01/2021.
//

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"
#import "CommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic , copy) CommentModel * model;

@property (nonatomic, copy) void(^commentClickCallBack)(MLLink *link,NSString *linkText,MLLinkLabel *label);

@end

NS_ASSUME_NONNULL_END
