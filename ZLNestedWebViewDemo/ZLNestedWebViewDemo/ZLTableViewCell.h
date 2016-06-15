//
//  ZLTableViewCell.h
//  ZLNestedWebViewDemo
//
//  Created by liuchao on 16/6/15.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ZLTableViewCellIdentifier = @"ZLTableViewCellIdentifier";

@interface ZLTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *ui_webView;

@property (assign, nonatomic) CGFloat zlCellHeight;

@end
