//
//  UIColor+Category.m
//  CategoryAndSubClassForOC
//
//  Created by anjun on 1/28/15.
//  Copyright (c) 2015 汪安军. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor *)randomColor {
    
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0
                           green:arc4random_uniform(256)/255.0
                            blue:arc4random_uniform(256)/255.0
                           alpha:1.0];
}


UIColor *UIColorWithRGB(NSInteger r, NSInteger g, NSInteger b) {
    return UIColorWithRGBA(r, g, b, 1.0);
}
UIColor *UIColorWithRGBA(NSInteger r, NSInteger g, NSInteger b, CGFloat a) {
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a];
}

UIColor *UIColorWithRRGGBB(NSInteger _0xrrggbb) {
    NSInteger value = _0xrrggbb;
    NSInteger r = (value & 0xFF0000) >> 16;
    NSInteger g = (value & 0x00FF00) >>  8;
    NSInteger b =  value & 0x0000FF;
    return UIColorWithRGB(r, g, b);
}


CGColorRef CGColorWithRGB(NSInteger r, NSInteger g, NSInteger b) {
    return UIColorWithRGB(r, g, b).CGColor;
}
CGColorRef CGColorWithRGBA(NSInteger r, NSInteger g, NSInteger b, CGFloat a) {
    return UIColorWithRGBA(r, g, b, a).CGColor;
}
CGColorRef CGColorWithRRGGBB(NSInteger _0xrrggbb) {
    return UIColorWithRRGGBB(_0xrrggbb).CGColor;
}

@end
