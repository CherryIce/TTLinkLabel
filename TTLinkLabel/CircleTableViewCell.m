//
//  CircleTableViewCell.m
//  TTLinkLabel
//
//  Created by Mr.Zhu on 18/01/2021.
//

#import "CircleTableViewCell.h"

@interface CircleTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet MLLinkLabel *linkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkH;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonH;

@property (weak, nonatomic) IBOutlet UIView *imgContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVH;

@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet MLLinkLabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationH;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIView *commentView;/**点赞和评论*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentH;

@end

@implementation CircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _linkLabel.lineSpacing = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CircleModel *)model {
    _model = model;
    self.linkH.constant = model.textH;
    self.imgVH.constant = model.imagesH;
    self.moreBtn.hidden = !model.isNeedMoreBtn;
    self.buttonH.constant = model.isNeedMoreBtn ? 30 : 0;
    self.locationH.constant = model.location.length > 0 ? 25 : 0;
    self.commentH.constant = model.commentH;
    self.deleteBtn.hidden = !model.isMe;
    [self updateUI:model.isExpand];
}

- (IBAction)moreBtnClick:(UIButton *)sender {
    BOOL isExpand = NO;
    if ([sender.titleLabel.text isEqualToString:@"全文"]) {
        isExpand = YES;
    }else if([sender.titleLabel.text isEqualToString:@"收起"]){
        isExpand = NO;
    }
    if (self.refreshCellUI) {
        self.refreshCellUI(isExpand);
    }
}

#pragma mark - 按钮做法
- (void) updateUI:(BOOL)isOpening {
    self.userNameLabel.text = _model.name;
    self.locationLabel.text = _model.location;
    self.timeLabel.text = _model.addtime;
    self.linkLabel.text = _model.text;
    if (_model.isNeedMoreBtn) {
        if (isOpening) {
            [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self.linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickLink:linkText:linkLabel:)]) {
            [weakSelf.delegate didClickLink:link linkText:linkText linkLabel:label];
        }
    }];
    
    if (_model.location) {
        [self.locationLabel addLinkWithType:MLLinkTypeOther value:_model.location range:NSMakeRange(0, _model.location.length)];
        [self.locationLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickLink:linkText:linkLabel:)]) {
                [weakSelf.delegate didClickLink:link linkText:linkText linkLabel:label];
            }
        }];
    }
}

- (IBAction)deleteClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCurrentCircle:)]) {
        [self.delegate deleteCurrentCircle:_model];
    }
}

- (IBAction)commentClick:(UIButton*)sender {
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        if (@available(iOS 13.0, *)) {
            [menu hideMenuFromView:sender.superview];
        }else{
            [menu setMenuVisible:NO animated:YES];
        }
    }
    menu.arrowDirection = UIMenuControllerArrowRight;
    UIMenuItem * item = [[UIMenuItem alloc] initWithTitle:@"点赞" action:@selector(likeThis:)];
    UIMenuItem * item1 = [[UIMenuItem alloc] initWithTitle:@"评论" action:@selector(commentThis:)];
    [menu setMenuItems:@[item, item1]];
    
    if (@available(iOS 13.0, *)) {
        [menu showMenuFromView:sender.superview rect:sender.frame];
    }else{
        [menu setTargetRect:sender.frame inView:sender.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

// 不设置这个方法,会导致无法调出menu菜单
- (BOOL)canBecomeFirstResponder {
    return YES;
}

// 再此方法中判断允许的方法,否则菜单项不弹出
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(likeThis:) || action == @selector(commentThis:)) {
        return YES;
    }
    return NO;
}

// 实现方法，完成功能
- (void)likeThis:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeCurrentCircle:)]) {
        [self.delegate likeCurrentCircle:_model];
    }
}

- (void)commentThis:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentCurrentCircle:)]) {
        [self.delegate commentCurrentCircle:_model];
    }
}

@end
