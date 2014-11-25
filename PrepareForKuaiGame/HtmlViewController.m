//
//  HtmlViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/11/25.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "HtmlViewController.h"

@interface HtmlViewController ()<UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@end

@implementation HtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_webView];
    
    //
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"html" ofType:@"html"];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:[NSBundle mainBundle].bundlePath];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    _webView.delegate = self;
    [_webView loadHTMLString:htmlString baseURL:baseURL];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    //只单独处理Appfactory的请求
    if ([[url scheme] isEqualToString:@"appfactory"]) {
        
        if ([[url host] isEqualToString:@"button_src"]) {
            NSLog(@"点击原文链接");
        } else if ([[url host] isEqualToString:@"button_share"]){
            NSLog(@"点击分享");
        }
        
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"javascript:(function(){var srcButton = document.getElementById(\"button_src\");srcButton.onclick=function(){document.location = \"appfactory://button_src\";};var shareButton = document.getElementById(\"button_share\");shareButton.onclick=function(){document.location = \"appfactory://button_share\";}}())"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

@end
