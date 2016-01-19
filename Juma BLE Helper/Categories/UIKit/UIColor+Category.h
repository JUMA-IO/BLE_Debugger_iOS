//
//  UIColor+Category.h
//  CategoryAndSubClassForOC
//
//  Created by anjun on 1/28/15.
//  Copyright (c) 2015 汪安军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UIColor (Category)

+ (UIColor *)randomColor;

UIColor *UIColorWithRGB (NSInteger r, NSInteger g, NSInteger b);
UIColor *UIColorWithRGBA(NSInteger r, NSInteger g, NSInteger b, CGFloat a);
UIColor *UIColorWithRRGGBB(NSInteger _0xrrggbb);

CGColorRef CGColorWithRGB (NSInteger r, NSInteger g, NSInteger b);
CGColorRef CGColorWithRGBA(NSInteger r, NSInteger g, NSInteger b, CGFloat a);
CGColorRef CGColorWithRRGGBB(NSInteger _0xrrggbb);

@end
