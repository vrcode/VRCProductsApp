//
//  CellTextField.h
//  ProductsApp
//
//  Created by F on 6/6/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRCCellTextFieldDelegate.h"

/**
    Custom Table View Cell featuring a Text Field.
 */
@interface VRCCellTextField : UITableViewCell <UITextFieldDelegate>

/** Cell's text field */

@property (nonatomic) IBOutlet UITextField *textField;

/** Cell's delegate object used to notify about text field events. */

@property (nonatomic, weak)     id<VRCCellTextFieldDelegate>   delegate;

@end
