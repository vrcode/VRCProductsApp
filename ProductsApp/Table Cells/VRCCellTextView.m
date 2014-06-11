//
//  CellTextView.m
//  ProductsApp
//
//  Created by F on 6/6/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCCellTextView.h"


@implementation VRCCellTextView

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(cellTextViewEditingEndedForTag:withText:)]) {
            [_delegate cellTextViewEditingEndedForTag:self.tag withText:textView.text];
        }
    }
}

@end
