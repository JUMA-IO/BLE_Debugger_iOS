//
//  SendCell.h
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/7.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JumaDataModel;
@protocol SendCellDelegate;

@interface SendCell : UITableViewCell

@property (nonatomic, readonly) BOOL isTextFieldEditing;
@property (nonatomic, weak) id<SendCellDelegate> delegate;
@property (nonatomic, weak) JumaDataModel *dataModel;

+ (NSString *)reusedIdentifier;

@end

@protocol SendCellDelegate <NSObject>

- (void)sendCelldidChangeDataModel:(SendCell *)cell;

@end
