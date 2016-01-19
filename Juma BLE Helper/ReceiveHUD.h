//
//  ReceiveHUD.h
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/10.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
@class JumaDataModel;

@interface ReceiveHUD : MBProgressHUD

- (void)appendModel:(JumaDataModel *)model;

@end
