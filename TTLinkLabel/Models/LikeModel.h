//
//  LikeModel.h
//  TTLinkLabel
//
//  Created by Mr.Zhu on 22/01/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LikeModel : NSObject

//点赞昵称 实际情况可能需要用户id判断自己有没有点赞 还有其他信息等等 这里只测试不管后台逻辑
@property (nonatomic , copy) NSString * userName;

@end

NS_ASSUME_NONNULL_END
