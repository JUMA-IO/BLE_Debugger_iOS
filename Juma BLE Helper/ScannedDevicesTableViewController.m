//
//  ScannedDevicesTableViewController.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/7.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "ScannedDevicesTableViewController.h"
#import "ScannedDevicesCell.h"
#import "SendViewController.h"
#import "JumaConfig.h"

#import "NSArray+Block.h"
#import "NSTimer+Category.h"

#import <JumaBluetoothSDK/JumaBluetoothSDK.h>
#import <MBProgressHUD.h>

@interface ScannedDevicesTableViewController () <JumaManagerDelegate, JumaDeviceDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) JumaManager *manager;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary<JumaDevice *, NSNumber *> *> *devices;

@property (nonatomic, weak) MBProgressHUD *managerStateHUD;
@property (nonatomic, weak) MBProgressHUD *connectHUD;
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, weak) SendViewController *sendVC;

@end

@implementation ScannedDevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // print the version string of JumaBluetoothSDK
    NSLog(@"JumaBluetoothSDKVersionString = %@", JumaBluetoothSDKVersionString);
    
    self.manager = [[JumaManager alloc] initWithDelegate:self queue:nil options:nil];
    
    self.devices = @[].mutableCopy;
}

- (void)scan {
    NSDictionary *options = @{ JumaManagerScanOptionAllowDuplicatesKey : @YES };
    [self.manager scanForDeviceWithOptions:options];
}

- (IBAction)refresh:(UIRefreshControl *)sender {
    
    if (sender.isRefreshing) {
        [self scan];
        [self.devices removeAllObjects];
        [self.tableView reloadData];
    }
}

- (MBProgressHUD *)managerStateHUD {
    if (_managerStateHUD == nil) {
        _managerStateHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _managerStateHUD.mode = MBProgressHUDModeText;
        _managerStateHUD.dimBackground = YES;
        _managerStateHUD.detailsLabelFont = [UIFont boldSystemFontOfSize:15];
    }
    return _managerStateHUD;
}

#pragma mark - JumaManagerDelegate
- (void)managerDidUpdateState:(JumaManager *)manager {
    
    NSString *msg = nil;
    
    switch (manager.state) {
        case JumaManagerStatePoweredOn: {
            
            if (!manager.isScanning) {
                
                if (self.devices.count > 0) {
                    [self scan];
                }
                else {
                    [self.refreshControl beginRefreshing];
                    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
                }
            }
            break;
        }
            
        case JumaManagerStatePoweredOff:
            msg = @"The Bluetooth is currently powered off.";
            break;
            
        case JumaManagerStateUnauthorized:
            msg = @"The application is not authorized to use the Bluetooth.";
            break;
            
        case JumaManagerStateUnsupported:
            msg = @"The platform doesn't support the Bluetooth 4.0 technology";
            break;
            
        case JumaManagerStateResetting:
        case JumaManagerStateUnknown:
            msg = @"The state Bluetooth of is unknown, update imminent" ;
            break;
        default: NSAssert(NO, @"Enumeration value is not processed");  break;
    }
    
    if (manager.state == JumaManagerStatePoweredOn) {
        [_managerStateHUD hide:YES];
        self.view.userInteractionEnabled = YES;
    }
    else {
        self.managerStateHUD.detailsLabelText = msg;
        self.view.userInteractionEnabled = NO;
        [self.sendVC deviceDisconnectedWithError:nil];
    }
    
    // If the state moves below JumaManagerStatePoweredOff
    // all JumaDevice objects obtained from this manager become invalid and must be retrieved or discovered again
    if (manager.state < JumaManagerStatePoweredOff) {
        [self.devices removeAllObjects];
    }
}

- (void)manager:(JumaManager *)manager didDiscoverDevice:(JumaDevice *)device RSSI:(NSNumber *)RSSI {
    
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
    
    NSMutableDictionary<JumaDevice *, NSNumber *> *dict = [self.devices detect:^BOOL(NSMutableDictionary *object) {
        return object.allKeys.firstObject == device;
    }];
    
    RSSI = RSSI ?: @(127);
    
    if (dict) {
        dict[device] = RSSI;
        
        for (ScannedDevicesCell *cell in self.tableView.visibleCells) {
            if (cell.device == device) {
                cell.RSSI = RSSI;
                return;
            }
        }
    }
    else {
        dict = @{ device : RSSI }.mutableCopy;
        [self.devices addObject:dict];
        
        [self.tableView beginUpdates];
        NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:self.devices.count - 1 inSection:0] ];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)manager:(JumaManager *)manager didConnectDevice:(JumaDevice *)device {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self hideConnectHUD];
    
    SendViewController *sendVC = [[SendViewController alloc] init];
    sendVC.manager = manager;
    sendVC.device = device;
    sendVC.title = device.name;
    self.sendVC = sendVC;
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)manager:(JumaManager *)manager didDisconnectDevice:(JumaDevice *)device error:(NSError *)error {
    
    [self.sendVC deviceDisconnectedWithError:error];
}

- (void)manager:(JumaManager *)manager didFailToConnectDevice:(JumaDevice *)device error:(NSError *)error {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self failToConnect:device];
}

- (void)failToConnect:(JumaDevice *)device {
    
    [self.manager disconnectDevice:device];
    
    self.connectHUD.mode = MBProgressHUDModeText;
    self.connectHUD.labelText = FORMAT(@"did fail to connect %@", device.name);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self hideConnectHUD];
    });
}

- (void)hideConnectHUD {
    
    [self.connectHUD hide:YES];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScannedDevicesCell *cell = [tableView dequeueReusableCellWithIdentifier:[ScannedDevicesCell reusedIdentifier] forIndexPath:indexPath];
    cell.device = self.devices[indexPath.row].allKeys.firstObject;
    cell.RSSI = self.devices[indexPath.row].allValues.firstObject;
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.view.userInteractionEnabled = NO;
    
    JumaDevice *device = self.devices[indexPath.row].allKeys.firstObject;
    [self.manager connectDevice:device];
    
    self.connectHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.connectHUD.dimBackground = YES;
    self.connectHUD.labelText = FORMAT(@"connecting %@", device.name);
    
    
    // for the timeout case
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:NO block:^{
        __strong typeof(weakSelf) self = weakSelf;
        
        [self failToConnect:device];
    }];
}

@end
