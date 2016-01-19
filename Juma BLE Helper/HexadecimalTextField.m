//
//  HexadecimalTextField.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/8.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "HexadecimalTextField.h"

static NSString * const kMenloFontName = @"Menlo";

@implementation HexadecimalTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont fontWithName:kMenloFontName size:15];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = self.font;
        label.text = @"0x";
        [label sizeToFit];
        self.leftView = label;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.textAlignment = NSTextAlignmentLeft;
        
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
        
        //
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing:)];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        toolBar.backgroundColor = [UIColor whiteColor];
        toolBar.items = @[ flexibleItem, doneItem ];
        
        self.inputAccessoryView = toolBar;
    }

    return self;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    UILabel *label = (UILabel *)self.leftView;
    label.font = font;
    [label sizeToFit];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds = [super textRectForBounds:bounds];
    bounds.origin.x -= 7;
    bounds.size.width += 7;
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds = [super editingRectForBounds:bounds];
    bounds.origin.x -= 7;
    bounds.size.width += 10;
    return bounds;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    bounds = [super leftViewRectForBounds:bounds];
    bounds.origin.x += 7;
    return bounds;
}

+ (NSCharacterSet *)invertedHexadecimalSet {
    
    static NSMutableCharacterSet *set = nil;
    if (set == nil) {
        set = [NSMutableCharacterSet decimalDigitCharacterSet];
        [set addCharactersInString:@"abcdefABCDEF"];
        [set invert];
    }
    return set;
}

@end
