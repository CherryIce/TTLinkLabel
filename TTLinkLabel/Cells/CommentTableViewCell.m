//
//  CommentTableViewCell.m
//  TTLinkLabel
//
//  Created by Mr.Zhu on 25/01/2021.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell ()

@property (weak, nonatomic) IBOutlet MLLinkLabel *commentLab;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CommentModel *)model {
    _model = model;
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:model.replyName];
    //回复名字点击事件
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSLinkAttributeName:[NSString stringWithFormat:@"%zd",model.replyUserId]}
                            range:[model.replyName rangeOfString:model.replyName]];
    if (model.byReplyName.length > 0) {
        //被回复名字点击事件
        NSString * lastStr = [NSString stringWithFormat:@"回复%@",model.byReplyName];
        NSMutableAttributedString * lastAttr = [[NSMutableAttributedString alloc] initWithString:lastStr];
        [lastAttr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                  NSLinkAttributeName:[NSString stringWithFormat:@"%zd",model.byReplyUserId]}
                          range:[lastStr rangeOfString:model.byReplyName]];
        [attributedText appendAttributedString:lastAttr];
    }
    NSString * text = [NSString stringWithFormat:@"：%@",model.content];
    NSMutableAttributedString * contentAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText appendAttributedString:contentAttr];

    _commentLab.attributedText = attributedText;
    
    __weak typeof(self) weakSelf = self;
    [_commentLab setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        if (weakSelf.commentClickCallBack) {
            weakSelf.commentClickCallBack(link,linkText,label);
        }
    }];
}

@end
