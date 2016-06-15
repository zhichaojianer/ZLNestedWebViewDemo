//
//  ZLTableViewCell.m
//  ZLNestedWebViewDemo
//
//  Created by liuchao on 16/6/15.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import "ZLTableViewCell.h"

@interface ZLTableViewCell ()<UIWebViewDelegate>

@end

@implementation ZLTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //注意：一定要设置web的scollEnabled属性，否则会出现滑动异常问题
    [self.ui_webView.scrollView setScrollEnabled:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //获取Web的高度
    CGSize zlAdaptiveSize = [self.ui_webView sizeThatFits:CGSizeZero];
    self.zlCellHeight = zlAdaptiveSize.height;
    
    //重新设置web的frame
    self.ui_webView.frame = CGRectMake(0, 0, zlAdaptiveSize.width, zlAdaptiveSize.height);

    //通知发送高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZLUpdateCellHeightNotification"
                                                        object:self
                                                      userInfo:nil];
}

@end
