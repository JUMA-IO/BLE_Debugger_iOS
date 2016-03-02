//
//  WebViewController.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 16/3/2.
//  Copyright © 2016年 JUMA. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

@end
