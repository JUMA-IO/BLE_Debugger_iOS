//
//  JumaDataModel.h
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/8.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const JumaDataModelsStoreKey;

@interface JumaDataModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;

- (instancetype)initWithType:(NSString *)type content:(NSString *)content;
+ (instancetype)dataModelWithType:(NSString *)type content:(NSString *)content;

+ (NSMutableArray<JumaDataModel *> *)dataModelsFromUserDefaults;

@end
