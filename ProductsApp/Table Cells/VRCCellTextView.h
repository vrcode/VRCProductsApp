//
//  CellTextView.h
//  ProductsApp
//
//  Created by F on 6/6/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRCCellTextViewDelegate.h"

/**
    Custom Table View Cell featuring a Text View.
 */

@interface VRCCellTextView : UITableViewCell <UITextViewDelegate>

/** Cell's text view */
@property (nonatomic) IBOutlet UITextView *textView;

/** Cell's delegate object used to notify about text view events. */

@property (nonatomic, weak)     id<VRCCellTextViewDelegate>    delegate;

@end
