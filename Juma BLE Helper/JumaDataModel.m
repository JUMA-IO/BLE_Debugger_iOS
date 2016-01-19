//
//  JumaDataModel.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/8.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "JumaDataModel.h"
#import "JumaConfig.h"
#import "HexadecimalTextField.h"
#import <MJExtension.h>

NSString * const JumaDataModelsStoreKey = @"JumaDataModelsStoreKey";

@interface JumaDataModel ()

@end

@implementation JumaDataModel

MJExtensionCodingImplementation

- (instancetype)initWithType:(NSString *)type content:(NSString *)content {
    
    if (self = [super init]) {
        _type = [type copy];
        _content = [content copy];
    }
    return self;
}

+ (instancetype)dataModelWithType:(NSString *)type content:(NSString *)content {
    return [[self alloc] initWithType:type content:content];
}

+ (NSMutableArray<JumaDataModel *> *)dataModelsFromUserDefaults {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *temp = [defaults arrayForKey:JumaDataModelsStoreKey];
    
    NSMutableArray *models = @[].mutableCopy;
    for (NSData *data in temp) {
        [models addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    
    if (models.count == 0) {
        for (int i = 0; i < 9; i++) {
            JumaDataModel *model = [[JumaDataModel alloc] init];
            model.type = FORMAT(@"0%d", i);
            model.content = @"00";
            [models addObject:model];
        }
    }
    
    return models;
}

- (void)setContent:(NSString *)content {
    
    NSCharacterSet *set = [HexadecimalTextField invertedHexadecimalSet];
    NSArray *temp = [content componentsSeparatedByCharactersInSet:set];
    _content = [temp componentsJoinedByString:@""].uppercaseString;
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@" type = %@, content = %@", self.type, self.content];
}

@end
