//
//  FakeDevice.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 16/3/9.
//  Copyright © 2016年 JUMA. All rights reserved.
//

#import "FakeDevice.h"

#if SCREENSHOT_MODE

@implementation FakeDevice

+ (instancetype)deviceWithName:(NSString *)name UUID:(NSString *)UUID {
    FakeDevice *device = [[super alloc] init];
    device->_fakeName = [name copy];
    device->_fakeUUID = [UUID copy];
    return device;
}

- (NSString *)name {
    return self->_fakeName;
}

- (NSString *)UUID {
    return self->_fakeUUID;
}

@end

#endif
