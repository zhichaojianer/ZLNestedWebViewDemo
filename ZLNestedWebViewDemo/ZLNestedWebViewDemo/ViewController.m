//
//  ViewController.m
//  ZLNestedWebViewDemo
//
//  Created by liuchao on 16/6/15.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import "ViewController.h"
#import "ZLTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView  *ui_tableView;

@property (strong, nonatomic) NSMutableArray      *zlHTMLStrArray;
@property (strong, nonatomic) NSMutableDictionary *zlHeightDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(zlUpdateCellHeightNotification:)
                                                 name:@"ZLUpdateCellHeightNotification"
                                               object:nil];
    
    UINib *zlNib = [UINib nibWithNibName:@"ZLTableViewCell" bundle:nil];
    [self.ui_tableView registerNib:zlNib forCellReuseIdentifier:ZLTableViewCellIdentifier];
    
    NSString *zlHTMLStr1 = [NSString stringWithFormat:@"<html><head><div>这是一个测试Demo，主要是为了验证在UITableViewCell中嵌套UIWebView，并且Cell的高度是动态计算的，其高度依赖于web完全加载html字符串后所计算出来的高度</div></body></html>"];
    
    NSString *zlHTMLStr2 = @"<p><img src=\"http://p6.qhimg.com/t01961dfc5e21b225a9.jpg\"/></p><p><img src=\"http://pic9.nipic.com/20100904/4845745_195609329636_2.jpg\"/></p><p><img src=\"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg\"/></p>";
    
    NSString *zlHTMLStr3 = @"知了是一款基于教师、家长间的社交工具，使用者可以通过知了发布文字信息、图文信息以及设置定时发布，支持语音智能转文字输入；班级码是知了为每个实体班级生成的唯一识别码，使用者可以使用班级码加入指定班级，实现班群互动、家长互动。http://www.imzhiliao.com";
    
    self.zlHTMLStrArray = [NSMutableArray arrayWithObjects:zlHTMLStr1, zlHTMLStr2, zlHTMLStr3, nil];
    self.zlHeightDic = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zlHTMLStrArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZLTableViewCellIdentifier];
    [cell setTag:indexPath.row];  //给cell打上Tag
    
    NSString *zlHTMLStr = self.zlHTMLStrArray[indexPath.row];
    [cell.ui_webView loadHTMLString:zlHTMLStr baseURL:[NSURL URLWithString:[[NSBundle mainBundle] bundlePath]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [[self.zlHeightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark notification

- (void)zlUpdateCellHeightNotification:(NSNotification *) notification {
    ZLTableViewCell *cell = [notification object];
    NSLog(@"cell.zlCellHeight -> %f", cell.zlCellHeight);
    
    NSString *zlCellTagStr = [NSString stringWithFormat:@"%ld",cell.tag];
    CGFloat zlCellHeightF = [[self.zlHeightDic objectForKey:zlCellTagStr] floatValue];
    
    if (![self.zlHeightDic objectForKey:zlCellTagStr] || (zlCellHeightF != cell.zlCellHeight)) {
        [self.zlHeightDic setObject:[NSNumber numberWithFloat:cell.zlCellHeight] forKey:zlCellTagStr];
        [self.ui_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
