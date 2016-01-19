//
//  SendTableViewController.h
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/14.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JumaDataModel;

@interface SendTableViewController : UITableViewController

@property (nonatomic, weak, readonly) JumaDataModel *selectedDataModel;

@end
