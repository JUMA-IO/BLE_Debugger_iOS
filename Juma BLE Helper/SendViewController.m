//
//  SendViewController.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/7.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "SendViewController.h"
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

#import "SendTableViewController.h"

@interface SendViewController () <JumaDeviceDelegate, MBProgressHUDDelegate>

@property (nonatomic, weak) SendTableViewController *tableViewController;

@property (nonatomic, strong) NSMutableArray<JumaDataModel *> *receivedDataModels;
@property (nonatomic, weak) ReceiveViewController *receiveVC;


@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) ReceiveHUD *receiveHUD;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak, readonly) UIBarButtonItem *sendBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *disconnectBarButtonItem;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation SendViewController

- (void)setDevice:(JumaDevice *)device {
    _device = device;
    _device.delegate = self;
}

- (NSMutableArray<JumaDataModel *> *)receivedDataModels {
    if (_receivedDataModels == nil) {
        _receivedDataModels = @[].mutableCopy;
    }
    return _receivedDataModels;
}

- (UIBarButtonItem *)sendBarButtonItem {
    return self.navigationItem.rightBarButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    SendTableViewController *tableVC = [[SendTableViewController alloc] init];
    self.tableViewController = tableVC;
    [self addChildViewController:tableVC];
    [self.view addSubview:tableVC.view];
    
    [tableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@64);
        make.bottom.equalTo(self.toolBar.mas_top);
    }];
}


- (void)deviceDisconnectedWithError:(NSError *)error {
    self.sendBarButtonItem.enabled = NO;
    self.disconnectBarButtonItem.enabled = NO;
    
    if (!self.receiveHUD.isHidden) {
        [self.receiveHUD hide:YES];
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.tableViewController.view];
    
    static NSString *disconnectPrompt = @"The device has disconnected";
    if (![hud.labelText isEqualToString: disconnectPrompt]) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.tableViewController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.dimBackground = YES;
        hud.labelText = disconnectPrompt;
        hud.detailsLabelText = error ? FORMAT(@"error: %@", error.localizedDescription) : nil;
    }
}


- (MBProgressHUD *)HUD {
    if (_HUD == nil) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.tableViewController.view];
        _HUD.detailsLabelFont = [UIFont systemFontOfSize:15];
        _HUD.dimBackground = YES;
        _HUD.removeFromSuperViewOnHide = NO;
        [self.tableViewController.view addSubview:_HUD];
    }
    return _HUD;
}

- (void)send {
    
    [self.tableViewController.view endEditing:YES];
    
    self.sendBarButtonItem.enabled = NO;
    
    JumaDataModel *dataModel = self.tableViewController.selectedDataModel;
    NSData *data = dataModel.content.dataValue;
    unsigned char type = strtoul(dataModel.type.UTF8String, 0, 16);
    
    [self.device writeData:data type:type];
    [self.HUD show:YES];
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^{
        __strong typeof(weakSelf) self = weakSelf;
        
        [self hideHUDWithError:@"timeout"];
    }];
}

- (void)hideHUDWithError:(NSString *)error {
    
    if (error == nil) {
        [self.HUD hide:YES];
        self.sendBarButtonItem.enabled = YES;
    }
    else {
        self.HUD.detailsLabelText = FORMAT(@"error: %@" , error);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.HUD hide:YES];
            self.sendBarButtonItem.enabled = YES;
        });
    }
}

#pragma mark - <JumaDeviceDelegate>

- (void)device:(JumaDevice *)device didWriteData:(NSError *)error {
    
    [self.timer invalidate];
    self.timer = nil;
    [self hideHUDWithError:error.localizedDescription];
}

- (void)device:(JumaDevice *)device didUpdateData:(NSData *)data type:(const char)typeCode error:(NSError *)error {
    
    JumaDataModel *model = [[JumaDataModel alloc] init];
    
    if (error == nil) {
        model.type = FORMAT(@"%02x", typeCode);
        
        NSCharacterSet *set = [HexadecimalTextField invertedHexadecimalSet];
        NSArray *temp = [data.description componentsSeparatedByCharactersInSet:set];
        NSString *string = [temp componentsJoinedByString:@""].uppercaseString;
        model.content = string;
    }
    
    [self.receivedDataModels addObject:model];
    [self.receiveHUD appendModel:model];
    [self.receiveHUD show:YES];
    self.sendBarButtonItem.enabled = NO;
    
    if (self.navigationController.visibleViewController == self.receiveVC) {
        self.receiveVC.dataModels = self.receivedDataModels;
    }
}

- (ReceiveHUD *)receiveHUD {
    
    if (_receiveHUD == nil && self.tableViewController.view) {
        _receiveHUD = [ReceiveHUD showHUDAddedTo:self.tableViewController.view animated:YES];
        _receiveHUD.removeFromSuperViewOnHide = NO;
        _receiveHUD.delegate = self;
    }
    return _receiveHUD;
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    if ([hud isKindOfClass:[ReceiveHUD class]]
        && self.device.state == JumaDeviceStateConnected
        && self.manager.state == JumaManagerStatePoweredOn) {
        self.sendBarButtonItem.enabled = YES;
    }
}

- (IBAction)disconnect:(UIBarButtonItem *)sender {
    self.sendBarButtonItem.enabled = NO;
    self.disconnectBarButtonItem.enabled = NO;
    [self.manager disconnectDevice:self.device];
}

- (IBAction)viewReceptionHistory {
    
    if (_receiveVC == nil) {
        ReceiveViewController *vc = [[ReceiveViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        self.receiveVC = vc;
    }
    
    self.receiveVC.dataModels = self.receivedDataModels;
}

- (void)dealloc {
    self.device.delegate = nil;
    [self disconnect:nil];
}

@end
