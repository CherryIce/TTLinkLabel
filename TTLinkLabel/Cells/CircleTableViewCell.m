//
//  CircleTableViewCell.m
//  TTLinkLabel
//
//  Created by Mr.Zhu on 18/01/2021.
//

#import "CircleTableViewCell.h"
#import <objc/message.h>
#import "ImgCollectionViewCell.h"
#import "CommentTableViewCell.h"

@interface CircleTableViewCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet MLLinkLabel *linkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkH;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonH;

@property (weak, nonatomic) IBOutlet UIView *imgContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVH;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;

@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet MLLinkLabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationH;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIView *commentView;/**点赞和评论*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentH;

@property (nonatomic, strong) MLLinkLabel * likeLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UITableView * cmTableView;

@end

@implementation CircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _linkLabel.lineSpacing = 10;
    _imgCollectionView.delegate = self;
    _imgCollectionView.dataSource = self;
    [_imgCollectionView registerNib:[UINib nibWithNibName:@"ImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImgCollectionViewCell"];
    
    //保证cell靠左
    SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
    if ([_imgCollectionView.collectionViewLayout respondsToSelector:sel]) {
        ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(_imgCollectionView.collectionViewLayout,sel,
                                                      @{@"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),
                                                        @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
                                                        @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
    }
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
    
    //是否文本能展开
    if (_model.isNeedMoreBtn) {
        if (isOpening) {
            [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
    }
    
    //文本
    __weak typeof(self) weakSelf = self;
    [self.linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickLink:linkText:clickType:)]) {
            [weakSelf.delegate didClickLink:link linkText:linkText clickType:CircleCellClickText];
        }
    }];
    
    //地址
    if (_model.location) {
        [self.locationLabel addLinkWithType:MLLinkTypeOther value:_model.location range:NSMakeRange(0, _model.location.length)];
        [self.locationLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickLink:linkText:clickType:)]) {
                [weakSelf.delegate didClickLink:link linkText:linkText clickType:CircleCellClickLoction];
            }
        }];
    }
    
    //图片
    if (_model.images.count > 0) {
        [self.imgCollectionView reloadData];
    }
    
    CGFloat top = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 72 - 16;
    //点赞
    if (_model.likes.count > 0) {
        NSString * likeString = nil;
        for (LikeModel * lm in _model.likes) {
            if (likeString) {
                likeString = [NSString stringWithFormat:@"%@,%@",likeString,lm.userName];
            }else{
                likeString = [NSString stringWithFormat:@" %@",lm.userName];
            }
        }
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
        for (LikeModel * lm in _model.likes) {
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
        
        self.likeLabel.hidden = NO;
        self.likeLabel.frame = CGRectMake(10, top, width - 20, 20);
        self.likeLabel.attributedText = attributedText;
        self.likeLabel.numberOfLines = 0;
        [_commentView addSubview:self.likeLabel];
        [self.likeLabel sizeToFit];
        
        [self.likeLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickLink:linkText:clickType:)]) {
                [weakSelf.delegate didClickLink:link linkText:linkText clickType:CircleCellClickUserName];
            }
        }];
        
        // 更新
        top = CGRectGetHeight(self.likeLabel.frame) + 5;
    }else{
        self.likeLabel.hidden = YES;
    }
    
    if ([_model.likes count] > 0 && [_model.comments count] > 0) {
        // 分割线
        self.lineView.hidden = NO;
        self.lineView.frame = CGRectMake(0, top, width/*CGRectGetWidth(_commentView.frame)*/, 0.5);
        self.lineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_commentView addSubview:self.lineView];
        // 更新
        top += 1;
    }else{
        self.lineView.hidden = YES;
    }
    
    // 处理评论
    if ([_model.comments count] > 0) {
        self.cmTableView.hidden = NO;
        self.cmTableView.frame = CGRectMake(10, top, width-20, _model.commentH - top);
        [_commentView addSubview:self.cmTableView];
        [self.cmTableView reloadData];
    }else{
        self.cmTableView.hidden = YES;
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
    //自己对发朋友圈人的评论
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentCurrentCircle:extraData:)]) {
        [self.delegate commentCurrentCircle:_model extraData:@(_model.userId)/**/];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImgCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //点击查看图片
    NSMutableArray * imgvs = [NSMutableArray array];
    [_model.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ImgCollectionViewCell *cell = (ImgCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        [imgvs addObject:cell.imgV];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImageItem:imageViews:)]) {
        [self.delegate didClickImageItem:indexPath.item imageViews:imgvs];
    }
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    ImageModel * im = _model.images.lastObject;
    CGFloat h = _model.images.count == 1 ? (_model.imageW * im.height / im.width - 10) : _model.imageW;
    return CGSizeMake(_model.imageW,h);
}

//此处间隙只针对section
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10,0,0,0);
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    cell.model = _model.comments[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.commentClickCallBack = ^(MLLink * _Nonnull link, NSString * _Nonnull linkText, MLLinkLabel * _Nonnull label) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickLink:linkText:clickType:)]) {
            [weakSelf.delegate didClickLink:link linkText:linkText clickType:CircleCellClickUserName];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentModel * model = _model.comments[indexPath.row];
    //自己对朋友圈的某条评论的回复
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentCurrentCircle:extraData:)]) {
        [self.delegate commentCurrentCircle:_model extraData:@(model.replyUserId)/*@"传那个被回复人的userid"*/];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel * model = _model.comments[indexPath.row];
    return model.contentH;
}

#pragma mark - getter
- (MLLinkLabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [[MLLinkLabel alloc] init];
        _likeLabel.numberOfLines = 0;
    }
    return _likeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _lineView;
}

- (UITableView *)cmTableView {
    if (!_cmTableView) {
        _cmTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cmTableView.backgroundColor = [UIColor clearColor];
        _cmTableView.delegate = self;
        _cmTableView.dataSource = self;
        _cmTableView.scrollEnabled = NO;
        [_cmTableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
        _cmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _cmTableView;;
}

@end
