//
//  DetailViewController.h
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "VRCAddColorViewController.h"
#import "VRCAddStoreViewController.h"
#import "VRCCellTextFieldDelegate.h"
#import "VRCCellTextViewDelegate.h"
#import "VRCCellPictureSelectorDelegate.h"


/**
    Product details view controller. It displays and allows to
    change all the properties of a product.
    
    It also is used to add new Products.
 */

@interface VRCProductViewController : UITableViewController <
    UISplitViewControllerDelegate,
    UIActionSheetDelegate,
    AddColorDelegate,
    AddStoreDelegate,
    VRCCellTextFieldDelegate,
    VRCCellTextViewDelegate,
    VRCCellPictureSelectorDelegate
>

/** Product object being displayed */

@property (nonatomic, weak) Product *product;

@end
