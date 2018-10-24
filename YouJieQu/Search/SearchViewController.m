//
//  SearchViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/17.
//  Copyright © 2018年 user. All rights reserved.
//

#import "SearchViewController.h"
#import <WebKit/WebKit.h>
@interface SearchViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *Back;
@property (strong, nonatomic) IBOutlet UIButton *Forword;
@property (strong, nonatomic) IBOutlet UIButton *Reload;
@property (strong, nonatomic) IBOutlet UIButton *Mall;
@property (strong, nonatomic) IBOutlet UIView *OperView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UITabBarItem *tabBar;
@property (strong, nonatomic) IBOutlet UIView *equalSafeView;
@property (strong, nonatomic) IBOutlet UIView *devView;
@property (strong ,nonatomic) NSString *webviewUrl;
@property (nonatomic, assign) NSInteger lastcontentOffset;
- (IBAction)loadMall:(id)sender;
- (IBAction)reload:(id)sender;
- (IBAction)goForword:(id)sender;
- (IBAction)goBack:(id)sender;



@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webviewUrl = @"http://www.youjiequ.com/index.php?r=index/classify";
    [self webviewWithUrl:_webviewUrl];
    
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:_OperView];
    [self.view bringSubviewToFront:_devView];
    
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
    configutation.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    [self.view addSubview:_webView];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    _webView.scrollView.delegate = self;
    
    NSLayoutConstraint *webViewLeft = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self.view addConstraint:webViewLeft];
    
    NSLayoutConstraint *webViewRight = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraint:webViewRight];
    
    NSLayoutConstraint *webViewBottom = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:webViewBottom];
    
    NSLayoutConstraint *webViewTop = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_progressView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:webViewTop];
    
    
    _webView.allowsBackForwardNavigationGestures=YES;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    _webView.scrollView.delegate = nil;
}

#pragma mark - WKNavigationDelegate method
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
//    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
    
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKNavigationDelegate method 解决重定向无法打开新页面的情况
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressView.alpha = 1.0f;
        
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.progressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark - 上下滑隐藏显示底部view
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat hight = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - self.lastcontentOffset;
    self.lastcontentOffset = contentOffset;
    
    if (offset > 0 && contentOffset > 0) {
        //        NSLog(@"上拉行为");
        [UIView animateWithDuration:0.6 animations:^ {
            self.OperView.transform = CGAffineTransformMakeTranslation(0,  self.tabBarController.tabBar.bounds.size.height);
            
            self.OperView.transform = CGAffineTransformMakeTranslation(0, self.OperView.bounds.size.height+ self.tabBarController.tabBar.bounds.size.height);
            self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height-self.equalSafeView.bounds.size.height) ;
            self.devView.transform = CGAffineTransformMakeTranslation(0, self.devView.bounds.size.height + self.OperView.bounds.size.height + self.tabBarController.tabBar.bounds.size.height);
            
            
        }];
    }
    if (offset < 0 && distanceFromBottom  > hight) {
        //        NSLog(@"下拉行为");
        //        NSLog(@"%f", offset);
        
        
        [UIView animateWithDuration:0.6 animations:^ {
            self.devView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.OperView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    if (contentOffset == 0) {
        //        NSLog(@"滑动到顶部");
        
        [UIView animateWithDuration:0.6 animations:^ {
            self.devView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.OperView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        
    }
    //    if (distanceFromBottom < hight) {
    //        NSLog(@"滑动到底部");
    //
    //    }
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [self changeOperBtn];
}

-(void)changeOperBtn
{
    if (_webView.canGoBack) {
        _Back.alpha = 1;
        _Back.enabled = YES;
    }else{
        _Back.alpha = 0.3;
        _Back.enabled = NO;
    }
    
    if (_webView.canGoForward) {
        _Forword.alpha = 1;
        _Forword.enabled = YES;
    }else{
        _Forword.alpha = 0.3;
        _Forword.enabled = NO;
    }
    if ( [_webView.URL.absoluteString isEqualToString:_webviewUrl]) {
        _Mall.alpha = 0.3;
        _Mall.enabled = NO;
    }else{
        _Mall.alpha = 1;
        _Mall.enabled = YES;
    }
}


- (IBAction)loadMall:(id)sender {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webviewUrl]]];
}

- (IBAction)reload:(id)sender {
    [_webView reload];
}

- (IBAction)goForword:(id)sender {
    [_webView goForward];
}

- (IBAction)goBack:(id)sender {
    [_webView goBack];
}
@end
