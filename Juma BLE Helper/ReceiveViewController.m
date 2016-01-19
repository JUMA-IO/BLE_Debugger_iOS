//
//  ReceiveViewController.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/9.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "ReceiveViewController.h"
#import "JumaDataModel.h"
#import "JumaConfig.h"
#import <Masonry.h>

static NSString * const reusedID = @"ReceiveViewController";

@interface ReceiveViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Reception History";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reusedID];
}

- (void)setDataModels:(NSArray<JumaDataModel *> *)dataModels {
    _dataModels = dataModels;
    
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        
        [self.tableView beginUpdates];
        NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:_dataModels.count - 1 inSection:0] ];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.textLabel.font = [UIFont fontWithName:@"Menlo" size:15];
    
    JumaDataModel *model = self.dataModels[indexPath.row];
    if (model.type && model.content) {
        cell.textLabel.text = FORMAT(@"0x%@, 0x%@", model.type, model.content);
    }
    else {
        cell.textLabel.text = @"error occur";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.text = @"TYPE";
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"CONTENT";
    
    for (UILabel *label in @[typeLabel, contentLabel]) {
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
    }
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(@15);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
    return view;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = nil;
    NSString *message = nil;
    
    JumaDataModel *model = self.dataModels[indexPath.row];
    if (model.type && model.content) {
        title = FORMAT(@"type = 0x%@", model.type);
        message = FORMAT(@"content = 0x%@", model.content);
    }
    else {
        message = @"error occur";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
