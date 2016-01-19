//
//  SendViewController.h
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/7.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JumaManager;
@class JumaDevice;

@interface SendViewController : UIViewController

@property (nonatomic, weak) JumaManager *manager;
@property (nonatomic, weak) JumaDevice *device;

- (void)deviceDisconnectedWithError:(NSError *)error;

@end
