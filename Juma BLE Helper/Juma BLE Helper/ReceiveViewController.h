//
//  ReceiveViewController.h
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/9.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JumaDataModel;

@interface ReceiveViewController : UIViewController

@property (nonatomic, weak) NSArray<JumaDataModel *> *dataModels;

@end
