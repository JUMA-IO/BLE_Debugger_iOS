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

@interface MoreViewController ()

@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *URLActions;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"More";
    self.backBarButtonTitle = @"";
    self.URLActions = @[
                        @[ @"Buy Development Board",
                           @"Buy",
                           @"http://shop123943370.taobao.com/"
                           ],
                        @[ @"About JUMA",
                           @"About JUMA",
                           @"http://www.juma.io/about.html"
                           ]
                        ];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.URLActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"url";
    NSArray<NSString *> *URLAction = self.URLActions[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = URLAction[0];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSArray<NSString *> *URLAction = self.URLActions[indexPath.row];
    
    WebViewController *webVC = [segue destinationViewController];
    webVC.title = URLAction[1];
    webVC.url = [NSURL URLWithString:URLAction[2]];
}

@end
