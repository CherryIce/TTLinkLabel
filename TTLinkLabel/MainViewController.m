//
//  MainViewController.m
//  TTLinkLabel
//
//  Created by hubin on 26/01/2021.
//

#import "MainViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tableView;

@property (nonatomic , strong) NSArray * dataArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Circle";
    [self loadData];
}

- (void) loadData {
    self.dataArray = @[@"纯文本",@"文本+多图",@"文章链接",@"文本+文章",@"视频",@"文本+视频",@"所有"];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Class clazz = NSClassFromString([self vcs][indexPath.row]);
    UIViewController *vc = [[clazz alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)vcs{
    return @[@"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController"];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
