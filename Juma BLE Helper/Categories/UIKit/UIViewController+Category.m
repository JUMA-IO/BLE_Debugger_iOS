//
//  UIViewController+Category.m
//  ObjC Categories
//
//  Created by 汪安军 on 15/7/27.
//  Copyright (c) 2015年 Wang AnJun. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

- (NSString *)backBarButtonTitle {
    return self.navigationItem.backBarButtonItem.title;
}

- (void)setBackBarButtonTitle:(NSString *)backBarButtonTitle {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backBarButtonTitle style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
