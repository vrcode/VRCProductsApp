//
//  CellTextFieldDelegate.h
//  ProductsApp
//
//  Created by F on 6/7/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    Protocol for CellTextField delegates
 */

@protocol VRCCellTextFieldDelegate <NSObject>

/**
    Called when the cell's TextField has finished
    editing.
 */

- (void)cellTextFieldEditingEndedForTag:(NSInteger)tag withText:(NSString *)text;

@end
