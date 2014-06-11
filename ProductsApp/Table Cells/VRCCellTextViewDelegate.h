//
//  CellTextViewDelegate.h
//  ProductsApp
//
//  Created by F on 6/7/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    Protocol for CellTextView delegates
 */

@protocol VRCCellTextViewDelegate <NSObject>

/**
    Called when the cell's TextView has finished
    editing (in this implementation, when return is pressed).
 */

- (void)cellTextViewEditingEndedForTag:(NSInteger)tag withText:(NSString *)text;

@end
