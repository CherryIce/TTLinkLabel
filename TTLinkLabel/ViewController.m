//
//  ViewController.m
//  TTLinkLabel
//
//  Created by Mr.Zhu on 08/01/2021.
//

#import "ViewController.h"
#import "MLLinkLabel.h"
#import <CoreText/CoreText.h>

@interface ViewController ()

@property (nonatomic , strong) MLLinkLabel * linkLabel;

@property (nonatomic , strong) UIButton * moreBtn;

@end

#define showAllText @"showAllText"
#define showSome @"showSome"
#define numberOfLine 4

@implementation ViewController

- (MLLinkLabel *)linkLabel {
    if (!_linkLabel) {
        _linkLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(15.0, 100.0, CGRectGetWidth(self.view.frame)-30.0, 0)];
        _linkLabel.font = [UIFont systemFontOfSize:16];
        _linkLabel.numberOfLines = numberOfLine;
        _linkLabel.lineSpacing = 10;
        [self.view addSubview:_linkLabel];
    }
    return _linkLabel;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_moreBtn setTitleColor:kDefaultLinkColorForMLLinkLabel forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //增加按钮的做法
    [self updateUI:NO];
    
//    //直接对字符串操作的做法
//    [self setLinkLabelAttStr:NO];
}

- (void) moreBtnClick:(UIButton *) sender {
    if ([sender.titleLabel.text isEqualToString:@"全文"]) {
        [self updateUI:YES];
    }else if([sender.titleLabel.text isEqualToString:@"收起"]){
        [self updateUI:NO];
    }
}

#pragma mark - 按钮做法
- (void) updateUI:(BOOL)isOpening {
    // 明月几时有？把酒问青天。http://google.com?login=2006 明月几时有？把酒问青天。
    NSString *text = @"明月几时有？把酒问青天。www.google.com?login=2021, 不知天上宫阙，今夕是何年。13612341234,我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间？转朱阁，低绮户，照无眠。不应有恨，何事长向别时圆？人有悲欢离合，月有阴晴圆缺，此事古难全。但愿人长久，千里共婵娟。";
    self.linkLabel.numberOfLines = 0;
    self.linkLabel.text = text;
    [self.linkLabel sizeToFit];
    CGRect frame = self.linkLabel.frame;
    if (self.linkLabel.frame.size.height > 90) {
        self.moreBtn.hidden = NO;
        if (isOpening) {
            [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            [self.linkLabel sizeToFit];
        }else{
            frame.size.height  = 90;
            self.linkLabel.frame = frame;
            [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
        self.moreBtn.frame = CGRectMake(CGRectGetMinX(self.linkLabel.frame), CGRectGetMaxY(frame) + 10, 0, 0);
        [self.moreBtn sizeToFit];
    }else{
        self.moreBtn.hidden = YES;
        self.moreBtn.frame = CGRectZero;
    }
    [self.linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSLog(@"%ld  %@  %@", link.linkType, linkText, link.linkValue);
    }];
}

#pragma mark - NSMutableAttributedString
- (void) setLinkLabelAttStr:(BOOL)isOpening {
    NSString *text = @"明月几时有？把酒问青天。http://google.com,不知天上宫阙，今夕是何年。13612341234,我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间？转朱阁，低绮户，照无眠。不应有恨，何事长向别时圆？人有悲欢离合，月有阴晴圆缺，此事古难全。但愿人长久，千里共婵娟。";
    /**
     @"明月几时有？把酒问青天。http://google.com,不知天上宫阙，今夕是何年。13612341234,我欲乘风归去，又恐琼楼玉宇，高处不胜寒。";
     */
    //获取每行显示的文本
    self.linkLabel.text = text;
    NSArray *array = [self getSeparatedLinesFromLabel:self.linkLabel];
    if (array.count > 4) {
        if (isOpening) {
            self.linkLabel.numberOfLines = 0;
            NSString * allText = [NSString stringWithFormat:@"%@ 收起<",text];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:allText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:[UIColor blackColor]}];
            NSRange range = [attStr.string rangeOfString:@"收起<"];
            [attStr addAttribute:NSLinkAttributeName value:showSome range:range];
            self.linkLabel.attributedText = attStr;
        }else{
            self.linkLabel.numberOfLines = numberOfLine;
            //组合需要显示的文本
            NSString *line4String = array[3];
            NSString *showText = [NSString stringWithFormat:@"%@%@%@%@...  更多>", array[0], array[1], array[2], [line4String substringToIndex:line4String.length-5]];
            //设置label的attributedText
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:showText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:[UIColor blackColor]}];
            NSRange range = [attStr.string rangeOfString:@"更多>"];
            [attStr addAttribute:NSLinkAttributeName value:showAllText range:range];
            self.linkLabel.attributedText = attStr;
        }
    }
    [self.linkLabel sizeToFit];
    
    __weak typeof(self) weakSelf = self;
    [self.linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSLog(@"%ld  %@  %@", link.linkType, linkText, link.linkValue);
        if ([link.linkValue isEqualToString:showAllText]) {
            [weakSelf setLinkLabelAttStr:YES];
        }else if([link.linkValue isEqualToString:showSome]){
            [weakSelf setLinkLabelAttStr:NO];
        }
    }];
    
    //在设置了text后针对修改link样式的例子   //这段代码用断言可以更好的实现
    for (MLLink *link in self.linkLabel.links) {
        if ([link.linkValue isEqualToString:@"13612341234"]) {
            link.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
        }
    }
    [self.linkLabel invalidateDisplayForLinks];
}

- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect  rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines)
    {
      CTLineRef lineRef = (__bridge CTLineRef )line;
      CFRange lineRange = CTLineGetStringRange(lineRef);
      NSRange range = NSMakeRange(lineRange.location, lineRange.length);
      NSString *lineString = [text substringWithRange:range];
      [linesArray addObject:lineString];
    }
    return linesArray;
}

@end
