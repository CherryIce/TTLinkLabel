//
//  LikeModel.h
//  TTLinkLabel
//
//  Created by hubin on 22/01/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LikeModel : NSObject

//点赞昵称
@property (nonatomic , copy) NSString * userName;

//用户id
@property (nonatomic , assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
