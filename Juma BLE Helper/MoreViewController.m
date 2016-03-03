//
//  MoreViewController.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 16/3/2.
//  Copyright © 2016年 JUMA. All rights reserved.
//

#import "MoreViewController.h"
#import "WebViewController.h"
#import "UIViewController+Category.h"

#define URL(string) [NSURL URLWithString:string]

@interface MoreViewController ()

@property (nonatomic, strong) NSDictionary<NSString *, NSURL *> *URLDict;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"More";
    self.backBarButtonTitle = @"";
    self.URLDict = @{ @"购买开发板" : URL(@"http://shop123943370.taobao.com/"),
                      @"关于聚码" : URL(@"http://www.juma.io/about.html")};
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.URLDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"url";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.URLDict.allKeys[indexPath.row];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSString *cellText = cell.textLabel.text;
    
    WebViewController *webVC = [segue destinationViewController];
    webVC.url = self.URLDict[cellText];
    webVC.title = cellText;
}

@end
