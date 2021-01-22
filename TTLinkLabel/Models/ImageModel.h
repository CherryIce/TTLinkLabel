//
//  ImageModel.h
//  TTLinkLabel
//
//  Created by Mr.Zhu on 22/01/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject

//图片链接 有需要小图的可指定规则 eg:大图链接拼接参数取缩略图 实际情况可能还有其他信息等等 这里只测试不管后台逻辑
@property (nonatomic , copy) NSString * url;

//宽
@property (nonatomic , assign) float width;

//高
@property (nonatomic , assign) float height;

@end

NS_ASSUME_NONNULL_END
