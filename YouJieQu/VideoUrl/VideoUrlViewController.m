//
//  VideoUrlViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import "VideoUrlViewController.h"
#import <WebKit/WebKit.h>
#import "PlayVideoViewController.h"

@interface VideoUrlViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *equalSafeView;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, strong) NSString *videoUrl;
@property (strong, nonatomic) NSString *videoTitle;

- (IBAction)webReturn:(id)sender;
- (IBAction)closeView:(id)sender;
- (IBAction)webReload:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayVideo;
- (IBAction)openPlayVideoUrl:(id)sender;


@end

@implementation VideoUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];//不设置会导致push时右上角黑影闪烁
    
    

    
   
//    _webviewUrl = @"http://m.iqiyi.com/";
    [self webviewWithUrl:_webviewUrl];
//    urlEvent(image_aiyiqi, "http://m.iqiyi.com/");
//    urlEvent(image_tengxun, "http://m.v.qq.com");
//    urlEvent(image_souhu, "https://m.tv.sohu.com/");
//    urlEvent(image_youku, "https://www.youku.com/");
//    urlEvent(image_mangguo, "https://m.mgtv.com/");
//    urlEvent(image_tudou, "http://compaign.tudou.com/?");
//    urlEvent(image_m1905, "http://m.1905.com/");
//    urlEvent(image_leshi, "http://m.le.com/");
//    urlEvent(image_ppshipin, "http://m.pptv.com/?f=pptv");
//    urlEvent(image_lishipin, "http://www.pearvideo.com/?from=intro");
//    urlEvent(image_dongman, "http://m.iqiyi.com/dongman/");
//    urlEvent(image_dianshi, "http://wx.iptv789.com/?act=home");
   
  
}

- (void)viewWillAppear:(BOOL)animated
{
    // 注意，这个<span style="font-family: Arial, Helvetica, sans-serif;">interactivePopGestureRecognizer</span><span style="font-family: Arial, Helvetica, sans-serif;">属性是iOS 7才有的</span>
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}


#pragma mark - 加载网页
- (void)webviewWithUrl: (NSString *)Url {
    WKWebViewConfiguration *configutation = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller =[[WKUserContentController alloc] init];
    [controller addScriptMessageHandler:self name:@"observe"];
    configutation.userContentController = controller;
    NSURL *jsUrl = [NSURL URLWithString:Url];
    _webView=[[WKWebView alloc] init];
     configutation.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    [self.view addSubview:_webView];
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    
    NSLayoutConstraint *webViewLeft = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self.view addConstraint:webViewLeft];
    
    NSLayoutConstraint *webViewRight = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraint:webViewRight];
    
    NSLayoutConstraint *webViewBottom = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.btnPlayVideo attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:webViewBottom];
    
    NSLayoutConstraint *webViewTop = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_progress attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
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



- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    _webView.scrollView.delegate = nil;
}

#pragma mark - WKNavigationDelegate method
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
//    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else if (navigationAction.targetFrame == nil){
//         [webView loadRequest:navigationAction.request];
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
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.webView  ) {
             CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            self.progress.alpha = 1.0f;
            [self.progress setProgress:newprogress animated:YES];
            if (newprogress >= 1.0f) {
                [UIView animateWithDuration:0.3f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.progress.alpha = 0.0f;
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0 animated:NO];
                                 }];
            }
            
            
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
       
        
        
       
        
    }
    } else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView) {
            if (self.webView.title.length != 0) {
                self.videoTitle = self.webView.title;
            }
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    }
    else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    


}
    
//    else if ([keyPath isEqualToString:@"title"]){
//        if (object == self.webView) {
//            self.videoTitle = self.webView.title;
//        }else{
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//    }
    


- (IBAction)webReturn:(id)sender {
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

- (IBAction)closeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)webReload:(id)sender {
    [_webView reload];
}
- (IBAction)openPlayVideoUrl:(id)sender {
    
    [self performSegueWithIdentifier:@"openVideo" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PlayVideoViewController *pc = segue.destinationViewController;
    _videoUrl = [[_webView URL]absoluteString];
    pc.webTitle = _videoTitle;
    pc.videoUrl =_videoUrl;
    pc.jiexiUrl = _jiexiUrl;
}







@end
