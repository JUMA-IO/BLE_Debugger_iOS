//
//  SendTableViewController.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/14.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "SendTableViewController.h"
#import "SendCell.h"
#import "HexadecimalTextField.h"
#import "JumaDataModel.h"
#import "ReceiveViewController.h"
#import "NSArray+Block.h"
#import "NSString+Category.h"
#import "NSTimer+Category.h"
#import "JumaConfig.h"
#import <JumaBluetoothSDK/JumaBluetoothSDK.h>
#import <MBProgressHUD.h>
#import <Masonry.h>

#import "ReceiveHUD.h"

@interface SendTableViewController () <JumaDeviceDelegate, SendCellDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray<JumaDataModel *> *dataModels;

@end

@implementation SendTableViewController

- (JumaDataModel *)selectedDataModel {
    return self.dataModels[self.selectedIndexPath.row];
}

- (NSMutableArray<JumaDataModel *> *)dataModels {
    if (_dataModels == nil) {
        _dataModels = [JumaDataModel dataModelsFromUserDefaults];
    }
    return _dataModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[SendCell class] forCellReuseIdentifier:[SendCell reusedIdentifier]];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SendCell *cell = [tableView dequeueReusableCellWithIdentifier:[SendCell reusedIdentifier] forIndexPath:indexPath];
    cell.dataModel = self.dataModels[indexPath.row];
    cell.delegate = self;
    
    if (!self.selectedIndexPath) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    BOOL shouldCheck = [indexPath isEqual:self.selectedIndexPath];
    cell.accessoryType = shouldCheck ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
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
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    self.selectedIndexPath = indexPath;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
}

#pragma mark - SendCellDelegate

- (void)syncDataModels {
    NSArray *temp = [self.dataModels map:^NSData *(JumaDataModel *object) {
        return [NSKeyedArchiver archivedDataWithRootObject:object];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:JumaDataModelsStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sendCelldidChangeDataModel:(SendCell *)cell {
    [self syncDataModels];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
