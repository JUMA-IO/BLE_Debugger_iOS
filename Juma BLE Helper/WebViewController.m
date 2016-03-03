//
//  WebViewController.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 16/3/2.
//  Copyright © 2016年 JUMA. All rights reserved.
//

#import "WebViewController.h"
#import "JumaConfig.h"

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, weak) UIButton *refreshButton;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    [self loadURL];
}

#pragma mark - private

- (void)loadURL {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)refresh {
    [self.refreshButton removeFromSuperview];
    [self loadURL];
}

#pragma mark - <UIWebViewDelegate>

- (void)webViewDidStartLoad:(UIWebView *)webView {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    self.navigationItem.titleView = indicatorView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.titleView = nil;
    self.navigationItem.title = self.title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    JMLog(@"加载连接 %@ 失败, error = %@", self.url, error);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = [UIScreen mainScreen].bounds;
    [button setTitle:@"网络错误, 点击刷新" forState: UIControlStateNormal];
    [button addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    self.refreshButton = button;
    [self webViewDidFinishLoad:self.webView];
}

@end
