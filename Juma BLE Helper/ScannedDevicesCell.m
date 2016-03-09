//
//  ScannedDevicesCell.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/7.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "ScannedDevicesCell.h"
#import <JumaBluetoothSDK/JumaBluetoothSDK.h>

#import "NSTimer+Category.h"

static const NSInteger kCountForDisableLabels = 5;

@interface ScannedDevicesCell ()

@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic) NSInteger notUpdateRssiCount;

@end

@implementation ScannedDevicesCell

+ (NSString *)reusedIdentifier {
    static NSString *reusedID = @"ScannedDevicesCell";
    return reusedID;
}

- (void)awakeFromNib {
    _rssiLabel.text = nil;
    _nameLabel.text = nil;
    _uuidLabel.text = nil;
}

- (void)setDevice:(JumaDevice *)device {
    _device = device;
    _nameLabel.text = device.name;
    _uuidLabel.text = device.UUID;
}

- (void)setRSSI:(NSNumber *)RSSI {
    
    if (RSSI.integerValue != 127) {
        _RSSI = RSSI;
        
        const NSInteger temp = self.notUpdateRssiCount;
        self.notUpdateRssiCount = 0;
        
        if (temp >= kCountForDisableLabels) {
            [self setupLabels];
        }
    }
#if !SCREENSHOT_MODE
    if (self.timer == nil) {
        
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^{
            __strong typeof(weakSelf) self = weakSelf;
            
            [self setupLabels];
        }];
    }
#endif
}

- (void)setupLabels {
    
    if (self.RSSI) {
        self.rssiLabel.text = self.RSSI.stringValue;
    }
    
    self.notUpdateRssiCount++;
    
    BOOL enable = (self.notUpdateRssiCount < kCountForDisableLabels);
    self.rssiLabel.enabled = enable;
    self.nameLabel.enabled = enable;
    self.uuidLabel.enabled = enable;
    self.userInteractionEnabled = enable;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
