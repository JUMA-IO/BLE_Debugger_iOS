//
//  ScannedDevicesCell.h
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/7.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JumaDevice;

@interface ScannedDevicesCell : UITableViewCell

@property (nonatomic, weak) JumaDevice *device;
@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic) NSInteger updateRssiCount;

+ (NSString *)reusedIdentifier;

@end
