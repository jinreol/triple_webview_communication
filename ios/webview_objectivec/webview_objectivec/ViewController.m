//
//  ViewController.m
//  webview_objectivec
//
//  Created by jinreol kim on 14/10/2019.
//  Copyright © 2019 jinreol kim. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
}

- (void)loadView {
    [super loadView];
    NSLog(@"loadView");
    
    NSString *targetURL = @"http://172.20.10.8:8888";
    
    WKUserContentController *contentController;
    WKWebViewConfiguration *config;
    WKWebView *webView;
    
    contentController = [[WKUserContentController alloc] init];
    
    [contentController addScriptMessageHandler:self name:@"web_to_ios"];
    config = [[WKWebViewConfiguration alloc] init];
    [config setUserContentController: contentController];
    
    //CGRect *frame;
    webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    
    [webView setUIDelegate:self];
    [webView setNavigationDelegate:self];
    
    self.view = webView;
    
    NSURL *url = [NSURL URLWithString:targetURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

//--------------------------------------------------//
//  WKNavigationDelegate                            //
//--------------------------------------------------//
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"웹뷰가 웹 컨텐츠를 받기 시작할 때 호출됩니다.");
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"웹 컨텐츠가 웹뷰에서 로드되기 시작할 때 호출됩니다.");
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"웹뷰가 서버 리디렉션을 수신 할 때 호출됩니다.");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"탐색 중에 오류가 발생하면 호출됩니다.");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"웹보기가 내용을로드하는 동안 오류가 발생하면 호출됩니다.");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"탐색이 완료되면 호출됩니다.");
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"웹뷰의 웹 콘텐츠 프로세스가 종료 될 때 호출됩니다.");
}


//--------------------------------------------------//
//  WKUIDelegate                                    //
//--------------------------------------------------//
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"자바스크립트 alert를 표시합니다.");
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:TRUE completion:nil];
    completionHandler();
    
}

//--------------------------------------------------//
//  WKNavigation                                    //
//--------------------------------------------------//
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"name: %@", [message name]);
    NSLog(@"body: %@", [message body]);
    
}

@end
