//
//  ReceiveHUD.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/10.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "ReceiveHUD.h"
#import "UIColor+Category.h"
#import "JumaDataModel.h"
#import <Masonry.h>

static const CGFloat kTableViewRowHeight = 30;
static const CGFloat kCloseButtonHeight = 35;
static const NSUInteger kMaxNumberOfModel = 5;

@interface ReceiveHUD () <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<JumaDataModel *> *dataModels;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ReceiveHUD

- (id)initWithView:(UIView *)view {
    
    if (self = [super initWithView:view]) {
        
        self.dataModels = @[].mutableCopy;
        
        self.mode = MBProgressHUDModeCustomView;
        self.dimBackground = YES;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width - 2 * 30, kCloseButtonHeight + kMaxNumberOfModel * kTableViewRowHeight)];
        self.customView.backgroundColor = [UIColor whiteColor];
        
        // title label in top
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"Did Receive Data";
        [self.customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.customView);
            make.top.equalTo(@8);
        }];
        
        // close button in top right corner
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        closeButton.layer.borderWidth = 1;
        closeButton.layer.borderColor = UIColorWithRGB(0, 96, 249).CGColor;
        closeButton.layer.cornerRadius = kCloseButtonHeight / 2;
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:23]];
        [closeButton setTitleColor:UIColorWithRGB(0, 96, 249) forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self.customView addSubview:closeButton];
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(self.customView);
            make.height.equalTo(@(kCloseButtonHeight));
            make.width.equalTo(@(kCloseButtonHeight));
        }];
        
        // table view
        UITableView *tableView = [[UITableView alloc] init];
        tableView.dataSource = self;
        tableView.userInteractionEnabled = NO;
        tableView.rowHeight = kTableViewRowHeight;
        self.tableView = tableView;
        [self.customView addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(closeButton.mas_bottom);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
        }];
        NSLog(@"");
    }
    
    return self;
}

- (void)close {
    [self hide:YES];
    [self.dataModels removeAllObjects];
}

- (void)appendModel:(JumaDataModel *)model {
    if (self.dataModels.count >= kMaxNumberOfModel) {
        [self.dataModels removeObjectAtIndex:0];
    }
    [self.dataModels addObject:model];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"ReceiveHUD";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.textLabel.font = [UIFont fontWithName:@"Menlo" size:15];
    }
    
    JumaDataModel *model = self.dataModels[indexPath.row];
    if (model.type && model.content) {
        cell.textLabel.text = [NSString stringWithFormat:@"0x%@, 0x%@", model.type, model.content];
    }
    
    return cell;
}

@end
