//
//  CircleModel.h
//  TTLinkLabel
//
//  Created by hubin on 18/01/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageModel.h"
#import "CommentModel.h"
#import "LikeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleModel : NSObject

//发朋友圈人的用户id
@property (nonatomic , assign) NSInteger userId;

//头像
@property (nonatomic , copy) NSString * icon;

//名字
@property (nonatomic , copy) NSString * name;

//类型
@property (nonatomic , copy) NSString * type;

//文本
@property (nonatomic , copy) NSString * text;

//展开与收缩
@property (nonatomic , assign) BOOL isExpand;

//文本是否达到展开要求
@property (nonatomic , assign) BOOL isNeedMoreBtn;

//图片数组
@property (nonatomic , copy) NSArray <ImageModel*>* images;

//地理位置
@property (nonatomic , copy) NSString * location;

//发布时间
@property (nonatomic , copy) NSString * addtime;

//当前账号是否是本人
@property (nonatomic , assign) BOOL isMe;

//评论数组
@property (nonatomic , copy) NSArray <CommentModel*>* comments;

//点赞数组
@property (nonatomic , copy) NSArray <LikeModel*>* likes;

//文本高度
@property (nonatomic , assign) CGFloat textH;

//图片显示区域高度
@property (nonatomic , assign) CGFloat imagesH;

//每张图片的显示宽度
@property (nonatomic , assign) CGFloat imageW;

//评论数组显示区域高度
@property (nonatomic , assign) CGFloat commentH;

//整个cell显示高度
@property (nonatomic , assign) CGFloat cellH;

@end

NS_ASSUME_NONNULL_END
