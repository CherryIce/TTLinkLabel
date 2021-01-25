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
    if (_images.count > 0) h += self.imagesH;
    if (_location.length > 0) h += 25;
    if (_comments.count > 0 || _likes.count > 0) h += self.commentH;
    return h;
}

/**
 图片排列方式
 */
- (CGFloat)imagesH {
    CGFloat h = 0;
    CGFloat imageSuperViewWidth = [UIScreen mainScreen].bounds.size.width - 2 * 72;
    //一张图的话可以按实际比列来 w > h 就限制宽等比例适配高 反之 h > w  就限制高等比例适配宽
    switch (_images.count) {
        case 1:{
            ImageModel * im = _images.lastObject;
            CGFloat wRate = im.width / imageSuperViewWidth;
            if (im.width > im.height) {
                //宽大于高
                if (wRate <= 1) {
                    //宽小于视图宽 不变
                    _imageW = im.width;
                    h = im.height;
                }else{
                    //宽大于视图宽 宽取比例变小 高随之等比例变小
                    _imageW = im.width / wRate;
                    h = im.height / wRate;
                }
            }else if(im.width == im.height) {
                //正方形
                if (wRate <= 1) {
                    //宽小于视图宽 不变
                    _imageW = im.width;
                    h = im.height;
                }else{
                    //宽大于视图宽 宽取比例变小 高随之等比例变小
                    _imageW = im.width / wRate;
                    h = im.height / wRate;
                }
            }else{
                //可能需要很多种判断 这里只做一种
                //固定高给90 宽自适应过来
                h = 90;
                _imageW = 90 * im.width / im.height;
            }
            
        }
            break;
        case 3:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            CGFloat singleWidth = (imageSuperViewWidth - 2 * 10)/3;//每行3个2个间隙
            NSInteger row = _images.count / 3;
            NSInteger result = _images.count % 3;
            NSInteger count = result==0 ? row : (row+1);//行数
            _imageW = singleWidth;
            h = (_imageW + 10) * count;//(count - 1) * 10
        }
            break;
        case 2:
        case 4:{
            //这里+1是为了打破colletionview一行布局三个的规律
            CGFloat singleWidth = (imageSuperViewWidth - 2 * 10)/3;//每行3个2个间隙
            NSInteger row = _images.count / 2;
            _imageW = singleWidth + 1;
            h = (_imageW + 10) * row;
        }
            break;
        default:
            break;
    }
    return h;
}

- (CGFloat)commentH {
    CGFloat h = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 72 - 16;
    if (_likes.count > 0) {
        NSString * likeString = nil;
        for (LikeModel * lm in _likes) {
            if (likeString) {
                likeString = [NSString stringWithFormat:@"%@,%@",likeString,lm.userName];
            }else{
                likeString = [NSString stringWithFormat:@" %@",lm.userName];
            }
        }
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
        for (LikeModel * lm in _likes) {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                            NSLinkAttributeName:[NSString stringWithFormat:@"%zd",lm.userId]}
                                    range:[likeString rangeOfString:lm.userName]];
        }
        
        //添加'赞'的图片
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"like"];
        textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attributedText insertAttributedString:imageStr atIndex:0];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 20, 20)];
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        [label sizeToFit];
        h = label.frame.size.height;
        h +=5;
    }
    if (_comments.count > 0) {
        for (CommentModel * cm in _comments) {
            h += cm.contentH;
        }
        h += 5;
    }
    if (_comments.count > 0 && _likes.count > 0) {
        h += 1;
    }
    return h;
}

@end
