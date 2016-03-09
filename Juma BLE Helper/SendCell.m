//
//  SendCell.m
//  Juma BLE Helper
//
//  Created by 汪安军 on 15/12/7.
//  Copyright © 2015年 JUMA. All rights reserved.
//

#import "SendCell.h"
#import "JumaDataModel.h"
#import "HexadecimalTextField.h"
#import "NSArray+Block.h"
#import "JumaConfig.h"
#import <Masonry.h>

@interface SendCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation SendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupLabels];
    return self;
}

- (void)setupLabels {
    
    HexadecimalTextField *typeTextField = [[HexadecimalTextField alloc] init];
    typeTextField.keyboardType = UIKeyboardTypeNumberPad;
    HexadecimalTextField *contentTextField = [[HexadecimalTextField alloc] init];
    contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    for (UITextField *textField in @[typeTextField, contentTextField]) {
        textField.delegate = self;
        [self addSubview:textField];
    }
    
    [typeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(8);
        make.width.equalTo(@55);
    }];
    
    [contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(typeTextField.mas_right).with.offset(8);
        make.right.equalTo(self).with.offset(-39);
    }];
    
    self.typeTextField = typeTextField;
    self.contentTextField = contentTextField;
    
}

- (BOOL)isTextFieldEditing {
    return self.typeTextField.isEditing || self.contentTextField.isEditing;
}

- (void)setDataModel:(JumaDataModel *)dataModel {
    _dataModel = dataModel;
    
    self.typeTextField.text = _dataModel.type;
    self.contentTextField.text = _dataModel.content;
}

+ (NSString *)reusedIdentifier {
    static NSString *reusedID = @"SendCell";
    return reusedID;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length <= 0) { // delete character
        return YES;
    }
    else { // type in character
        
        if (textField == self.typeTextField) {
            string = [(textField.text ?: @"") stringByAppendingString:string];
            unsigned char type = strtoul(string.UTF8String, NULL, 16);
            JMLog(@"string = %@, -> 0x%02x", string, type);

            if (type < 0x80) {
                return textField.text.length < 2;
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"type should be less than 0x80" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
                textField.text = nil;
                return NO;
            }
        }
        else {
            NSCharacterSet *set = [HexadecimalTextField invertedHexadecimalSet];
            NSArray *temp = [string componentsSeparatedByCharactersInSet:set];
            string = [temp componentsJoinedByString:@""].uppercaseString;
            
            textField.text = [textField.text stringByAppendingString:string];
            return NO;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    const NSUInteger length = textField.text.length;
    
    if (length == 0) {
        textField.text = @"00";
    }
    else {
        if (length % 2 != 0) {
            textField.text = [textField.text stringByAppendingString:@"0"];
        }
    }
    
    if (textField == self.typeTextField) {
        
        if (![self.dataModel.type isEqualToString:textField.text]) {
            self.dataModel.type = textField.text;
            [self.delegate sendCelldidChangeDataModel:self];
        }
    }
    else {
        
        if (![self.dataModel.content isEqualToString:textField.text]) {
            self.dataModel.content = textField.text;
            [self.delegate sendCelldidChangeDataModel:self];
        }
    }
    
    
}

@end
