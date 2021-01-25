//
//  CommentModel.m
//  TTLinkLabel
//
//  Created by Mr.Zhu on 22/01/2021.
//

#import "CommentModel.h"

@implementation CommentModel

- (float)contentH {
    CGFloat h = 0;
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:_replyName];
    //回复名字点击事件
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSLinkAttributeName:[NSString stringWithFormat:@"%zd",_replyUserId]}
                            range:[_replyName rangeOfString:_replyName]];
    if (_byReplyName.length > 0) {
        //被回复名字点击事件
        NSString * lastStr = [NSString stringWithFormat:@"回复%@",_byReplyName];
        NSMutableAttributedString * lastAttr = [[NSMutableAttributedString alloc] initWithString:lastStr];
        [lastAttr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                  NSLinkAttributeName:[NSString stringWithFormat:@"%zd",_byReplyUserId]}
                          range:[lastStr rangeOfString:_byReplyName]];
        [attributedText appendAttributedString:lastAttr];
    }
    NSString * text = [NSString stringWithFormat:@"：%@",_content];
    NSMutableAttributedString * contentAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText appendAttributedString:contentAttr];

    CGFloat width = [UIScreen mainScreen].bounds.size.width - 72 - 16;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 20, 20)];
    label.attributedText = attributedText;
    label.numberOfLines = 0;
    [label sizeToFit];
    h = label.frame.size.height;
//    h +=5;
    return h;
}

@end
