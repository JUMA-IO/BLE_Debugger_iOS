//
//  NSString+Category.h
//  CategoryAndSubClassForOC
//
//  Created by anjun on 1/28/15.
//  Copyright (c) 2015 汪安军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)

/** 把表示 16 进制数据的字符串转化为 16 进制数据 */
- (NSData *)dataValue;

@end
