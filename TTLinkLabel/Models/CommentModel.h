//
//  CommentModel.h
//  TTLinkLabel
//
//  Created by hubin on 22/01/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

//评论/回复人昵称
@property (nonatomic , copy) NSString * replyName;

//评论/回复人id
@property (nonatomic , assign) NSInteger replyUserId;

//评论或回复内容
@property (nonatomic , copy) NSString * content;

//被回复人昵称 存在即是回复 不存在即是评论 也可以使用其他使用方式 这里只是测试
@property (nonatomic , copy) NSString * byReplyName;

//被回复人id
@property (nonatomic , assign) NSInteger byReplyUserId;

//评论高度
@property (nonatomic , assign) float contentH;

@end

NS_ASSUME_NONNULL_END
