//
//  ViewController.m
//  TTLinkLabel
//
//  Created by Mr.Zhu on 08/01/2021.
//

#import "ViewController.h"
#import "CircleTableViewCell.h"
//#import "MLLinkLabel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,CircleTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) NSMutableArray * dataArray;

//@property (nonatomic , strong) MLLinkLabel * linkLabel;
//
//@property (nonatomic , strong) UIButton * moreBtn;

@end

@implementation ViewController

//- (MLLinkLabel *)linkLabel {
//    if (!_linkLabel) {
//        _linkLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(15.0, 100.0, CGRectGetWidth(self.view.frame)-30.0, 0)];
//        _linkLabel.font = [UIFont systemFontOfSize:16];
//        _linkLabel.numberOfLines = 0;
//        _linkLabel.lineSpacing = 10;
//        [self.view addSubview:_linkLabel];
//    }
//    return _linkLabel;
//}
//
//- (UIButton *)moreBtn {
//    if (!_moreBtn) {
//        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_moreBtn setTitleColor:kDefaultLinkColorForMLLinkLabel forState:UIControlStateNormal];
//        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_moreBtn];
//    }
//    return _moreBtn;
//}

//- (void) moreBtnClick:(UIButton *) sender {
//    if ([sender.titleLabel.text isEqualToString:@"全文"]) {
//        [self updateUI:YES];
//    }else if([sender.titleLabel.text isEqualToString:@"收起"]){
//        [self updateUI:NO];
//    }
//}
//
//#pragma mark - 按钮做法
//- (void) updateUI:(BOOL)isOpening {
//    // 明月几时有？把酒问青天。http://google.com?login=2006 明月几时有？把酒问青天。
//    NSString *text = @"明月几时有？把酒问青天。www.google.com?login=2021, 不知天上宫阙，今夕是何年。13612341234,我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间？转朱阁，低绮户，照无眠。不应有恨，何事长向别时圆？人有悲欢离合，月有阴晴圆缺，此事古难全。但愿人长久，千里共婵娟。";
//    self.linkLabel.text = text;
//    [self.linkLabel sizeToFit];
//    CGRect frame = self.linkLabel.frame;
//    if (self.linkLabel.frame.size.height > 90) {
//        self.moreBtn.hidden = NO;
//        if (isOpening) {
//            [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
//            [self.linkLabel sizeToFit];
//        }else{
//            frame.size.height  = 90;
//            self.linkLabel.frame = frame;
//            [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
//        }
//        self.moreBtn.frame = CGRectMake(CGRectGetMinX(self.linkLabel.frame), CGRectGetMaxY(frame) + 10, 0, 0);
//        [self.moreBtn sizeToFit];
//    }else{
//        self.moreBtn.hidden = YES;
//        self.moreBtn.frame = CGRectZero;
//    }
//    [self.linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//        NSLog(@"%ld  %@  %@", link.linkType, linkText, link.linkValue);
//    }];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLocalizedStringFromTable(<#key#>, <#tbl#>, <#comment#>)
    //增加按钮的做法
    //[self updateUI:NO];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CircleTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CircleTableViewCell class])];
    [self loadData];
}

- (void) loadData {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray * models = [result valueForKey:@"data"];
    for (NSDictionary * dic in models) {
        CircleModel * model = [CircleModel new];
        model.icon = [dic valueForKey:@"icon"];
        model.name = [dic valueForKey:@"name"];
        model.text = [dic valueForKey:@"text"];
        
        
        NSArray * images = [dic valueForKey:@"images"];
        NSMutableArray * imgs = [NSMutableArray array];
        for (NSDictionary * img in images) {
            ImageModel * im = [ImageModel new];
            im.url = [img valueForKey:@"url"];
            im.width = [[img valueForKey:@"width"] floatValue];
            im.height = [[img valueForKey:@"height"] floatValue];
            [imgs addObject:im];
        }
        model.images = imgs;
        
        NSArray * likeArr = [dic valueForKey:@"likes"];
        NSMutableArray * likes = [NSMutableArray array];
        for (NSDictionary * like in likeArr) {
            LikeModel * lk = [LikeModel new];
            lk.userName = [like valueForKey:@"userName"];
            [likes addObject:like];
        }
        model.likes = likes;
        
        NSArray * commentArr = [dic valueForKey:@"likes"];
        NSMutableArray * comments = [NSMutableArray array];
        for (NSDictionary * comment in commentArr) {
            CommentModel * cm = [CommentModel new];
            cm.replyName = [comment valueForKey:@"replyName"];
            cm.byReplyName = [comment valueForKey:@"byReplyName"];
            cm.content = [comment valueForKey:@"content"];
            [likes addObject:cm];
        }
        model.comments = comments;
        
        model.location = [dic valueForKey:@"location"];
        model.addtime = [dic valueForKey:@"addtime"];
        
        model.textH = [self caulTxtH:model.text];
        model.isExpand = NO;
        model.isNeedMoreBtn = model.textH > 90 ? YES : NO;
        if (model.isNeedMoreBtn) {
            model.textH = model.isExpand ? model.textH : 90;
        }else{
            model.textH = model.textH;
        }
        model.isMe = model.images.count == 0;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

- (CGFloat) caulTxtH:(NSString *)text {
    if (text.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
//    paraStyle.lineSpacing = 10;
//    paraStyle.headIndent = 0;
//    paraStyle.paragraphSpacingBefore = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paraStyle};
    CGRect frame = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 72 - 16, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return CGSizeMake(ceil(frame.size.width), ceil(frame.size.height) + 1).height;
}

#pragma mark - tableViewDelegate
//数据个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleModel * model = self.dataArray[indexPath.item];
    CircleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CircleTableViewCell class]) forIndexPath:indexPath];
    cell.model = model;
    __weak typeof(self) wself = self;
    cell.refreshCellUI = ^(bool isExpand) {
        model.isExpand = isExpand;
        model.textH = model.isExpand ? [wself caulTxtH:model.text] : 90;
        [wself refreshIndexPath:indexPath];
    };
    cell.delegate = self;
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleModel * model = self.dataArray[indexPath.item];
    return model.cellH;
}

#pragma mark - 文本展开和收缩
- (void) refreshIndexPath:(NSIndexPath *)indexPath {
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - CircleTableViewCellDelegate
- (void)deleteCurrentCircle:(CircleModel *)model {
    NSLog(@"确定要删除吗？");
}

- (void)likeCurrentCircle:(CircleModel *)model {
    NSLog(@"点赞/取消点赞");
}

- (void)commentCurrentCircle:(CircleModel *)model {
    NSLog(@"有爱评论 说点好听的");
}

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(id)linkLabel {
    NSLog(@"%ld  %@  %@", link.linkType, linkText, link.linkValue);
    //对应相应类型做操作
}

#pragma mark - getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
