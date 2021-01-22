//
//  CommentModel.h
//  TTLinkLabel
//
//  Created by Mr.Zhu on 22/01/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

//评论/回复人昵称 实际情况可能需要用户id 还有其他信息等等 这里只测试不管后台逻辑
@property (nonatomic , copy) NSString * replyName;

//评论或回复内容
@property (nonatomic , copy) NSString * content;

//被回复人昵称 存在即是回复 不存在即是评论 也可以使用其他使用方式 这里只是测试
@property (nonatomic , copy) NSString * byReplyName;

@end

NS_ASSUME_NONNULL_END
