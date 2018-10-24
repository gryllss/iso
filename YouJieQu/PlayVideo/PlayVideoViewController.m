//
//  PlayVideoViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <WebKit/WebKit.h>
#import "YBPopupMenu.h"

@interface PlayVideoViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate,YBPopupMenuDelegate>

@property (strong, nonatomic) IBOutlet UIButton *changeLine;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSArray *lines;
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) YBPopupMenu* rightPopMenu;//右侧更多下拉框
- (IBAction)reload:(id)sender;
- (IBAction)closeView:(id)sender;

@end

@implementation PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lines =@[@"https://jx.618g.com/?url=",
              @"https://api.97kn.com/?url=",
              @"http://yun.odflv.com/?url=",
              @"http://yun.baiyug.cn/vip/index.php?url=",
              @"http://yun.odflv.com/?url=",
              @"http://y.mt2t.com/lines?url=",
              @"https://www.1717yun.com/jx/ty.php?url=",
              @"http://jx.918jx.com/928/?url="];
    
       [self webviewWithUrl:[_lines[0]stringByAppendingString:_videoUrl]];
    [self.videoTitle setText:_webTitle];
    [self.changeLine addTarget:self action:@selector(pushMenu) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 加载网页
- (void)webviewWithUrl: (NSString *)Url {
    WKWebViewConfiguration *configutation = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller =[[WKUserContentController alloc] init];
    [controller addScriptMessageHandler:self name:@"observe"];
   
    configutation.userContentController = controller;
    NSURL *jsUrl = [NSURL URLWithString:Url];
    //    NSURL *jsUrl = [NSURL URLWithString:@"http://www.youjiequ.com/index.php?r=nine/wap"];
    //
    _webView=[[WKWebView alloc] init];
    [self.view addSubview:_webView];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
   
   
    
    NSLayoutConstraint *webViewLeft = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self.view addConstraint:webViewLeft];
    
    NSLayoutConstraint *webViewRight = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraint:webViewRight];
    
    NSLayoutConstraint *webViewBottom = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:webViewBottom];
    
    NSLayoutConstraint *webViewTop = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:webViewTop];
    
    
    _webView.allowsBackForwardNavigationGestures = NO;
    _webView.navigationDelegate=self;
    _webView.UIDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:jsUrl]];
}


- (void)userContentController:(WKUserContentController *)userContentController      didReceiveScriptMessage:(WKScriptMessage *)message {
    // Check to make sure the name is correct
    if ([message.name isEqualToString:@"observe"]) {        // Log out the message received
        NSLog(@"Received event %@", message.body);                NSString *sendCode = @"goToHtml();";
        [_webView evaluateJavaScript:sendCode completionHandler:nil];    }
    
}


#pragma mark - WKNavigationDelegate method
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}





-(void)setWebTitle:(NSString *)webTitle{
    _webTitle = webTitle;
    
}



- (IBAction)reload:(id)sender {
    [_webView reload];
}

- (IBAction)closeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)pushMenu{
    NSArray* items = @[@"线路一",@"线路二",@"线路三",@"线路四",@"线路五",@"线路六",@"线路七",@"线路八"];
    self.rightPopMenu = [YBPopupMenu showRelyOnView:_changeLine titles:items icons:nil menuWidth:125 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.isShowShadow = YES;
        popupMenu.showMaskView = NO;
        popupMenu.backColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.maxVisibleCount = 8;
        popupMenu.itemHeight = 44;
        popupMenu.minSpace = 12;
    }];
    self.rightPopMenu.delegate = self;
    
}

#pragma mark YBPopupMenuDelegate
-(void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
   
    [_webView loadRequest:[NSURLRequest requestWithURL:
                           [NSURL URLWithString:[_lines[index] stringByAppendingString:_videoUrl]]]];
    
    NSLog(@"%@", [_lines[index] stringByAppendingString:_videoUrl]);
}
@end
