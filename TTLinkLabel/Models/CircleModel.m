//
//  CircleModel.m
//  TTLinkLabel
//
//  Created by Mr.Zhu on 18/01/2021.
//

#import "CircleModel.h"

@implementation CircleModel

- (CGFloat)cellH {
    /**
     高度计算
     top : 16
     userName: 20
     padding: 10
     文本高度: _textH
     显示全文按钮: 30
     图片展示区域: _imagesH
     地理位置： 25
     发表时间: 20
     评论区: _commentH
     bottom: 10
     */
    //固定存在的是： top + userName + padding + 发表时间 + bottom
    CGFloat h = 16 + 20 + 10 + 20 + 10;
    if (_text.length > 0) h += _textH;
    if (_isNeedMoreBtn) h += 30;
    if (_images.count > 0) h += _imagesH;
    if (_location.length > 0) h += 25;
    if (_comments.count > 0 || _likes.count > 0) h += _commentH;
    return h;
}

- (CGFloat)imagesH {
    CGFloat h = 0;
    CGFloat imageSuperViewWidth = [UIScreen mainScreen].bounds.size.width - 2 * 72;
    //一张图的话可以按实际比列来 w > h 就限制宽等比例适配高 反之 h > w  就限制高等比例适配宽
    switch (_images.count) {
        case 1:{
            ImageModel * im = _images.lastObject;
            CGFloat imw = im.width;
            CGFloat imh = im.height;
            if (imw > imh) {
                imw = imageSuperViewWidth/2;
                imh = imw * imh / im.width;
            }
        }
            break;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            CGFloat singleWidth = (imageSuperViewWidth - 2 * 10)/3;//每行3个2个间隙
            NSInteger row = _images.count / 3;
            NSInteger result = _images.count % 3;
            NSInteger count = result==0 ? row : (row+1);//行数
            h = singleWidth * count + (count - 1) * 10;
        }
            break;
        default:
            break;
    }
    return h;
}

- (CGFloat)commentH {
    CGFloat h = 0;
    if (_likes.count > 0) {
        //主要看一排能不能显示完 能就20 不能就20 * N
        h = 20;
    }
    if (_comments.count > 0) {
        //计算评论的高度相对麻烦 测试先写死
        h += _comments.count * 20;
    }
    return h;
}

@end
