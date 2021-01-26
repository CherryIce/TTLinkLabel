//
//  ViewController.m
//  TTLinkLabel
//
//  Created by hubin on 08/01/2021.
//

#import "ViewController.h"
#import "CircleTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,CircleTableViewCellDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"图文";
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
            lk.userId = [[like valueForKey:@"userId"] integerValue];
            [likes addObject:lk];
        }
        model.likes = likes;
        
        NSArray * commentArr = [dic valueForKey:@"comments"];
        NSMutableArray * comments = [NSMutableArray array];
        for (NSDictionary * comment in commentArr) {
            CommentModel * cm = [CommentModel new];
            cm.replyName = [comment valueForKey:@"replyName"];
            cm.byReplyName = [comment valueForKey:@"byReplyName"];
            cm.content = [comment valueForKey:@"content"];
            cm.replyUserId = [[comment valueForKey:@"replyUserId"] integerValue];
            cm.byReplyUserId = [[comment valueForKey:@"byReplyUserId"] integerValue];
            [comments addObject:cm];
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

- (void)commentCurrentCircle:(CircleModel *)model extraData:(nonnull id)extraData {
    /**
     这里extraData 传过来的是被自己评论的用户id
     实际情况按实际处理
     */
    NSLog(@"有爱评论 说点好听的");
}

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText clickType:(CircleCellClickType)clickType{
    NSLog(@"%ld  %@  %@", link.linkType, linkText, link.linkValue);
    switch (clickType) {
        case CircleCellClickText:{
            //对应相应类型做操作
        }break;
        case CircleCellClickLoction:{
            //跳转地理位置详情
        }break;
        case CircleCellClickUserName:{
            // link.linkValue即userid 跳转个人详情页
        }break;
        default:
            break;
    }
}

- (void)didClickImageItem:(NSInteger)index imageViews:(NSArray *)imageViews {
    NSLog(@"%ld  %@  %@", index, imageViews[index], imageViews);
}

#pragma mark - getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CircleTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CircleTableViewCell class])];
    }
    return _tableView;
}

@end
