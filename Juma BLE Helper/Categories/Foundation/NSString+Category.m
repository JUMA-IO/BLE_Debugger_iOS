//
//  NSString+Category.m
//  CategoryAndSubClassForOC
//
//  Created by anjun on 1/28/15.
//  Copyright (c) 2015 汪安军. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (NSData *)dataValue {
    
    const char *chars = [self UTF8String];
    NSUInteger i = 0, len = self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return [data copy];
}

@end
