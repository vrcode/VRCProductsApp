//
//  CellTextField.m
//  ProductsApp
//
//  Created by F on 6/6/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCCellTextField.h"


@implementation VRCCellTextField

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(cellTextFieldEditingEndedForTag:withText:)]) {
            [_delegate cellTextFieldEditingEndedForTag:self.tag withText:self.textField.text];
        }
    }
}

@end
