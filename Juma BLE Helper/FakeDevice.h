//
//  FakeDevice.h
//  Juma BLE Helper
//
//  Created by 汪安军 on 16/3/9.
//  Copyright © 2016年 JUMA. All rights reserved.
//

#if SCREENSHOT_MODE

#import <JumaBluetoothSDK/JumaBluetoothSDK.h>

@interface FakeDevice : JumaDevice {
    NSString *_fakeName;
    NSString *_fakeUUID;
}

+ (instancetype)deviceWithName:(NSString *)name UUID:(NSString *)UUID;

@end

#endif
