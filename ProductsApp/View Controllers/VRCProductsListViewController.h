//
//  MasterViewController.h
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VRCProductViewController;

/**
    Displays the list of all the Products stored
    in the database.
 */

@interface VRCProductsListViewController : UITableViewController

/**
    Exposing products array so they can be
    read from other objects
 */

@property (nonatomic, readonly) NSMutableArray    *products;

@end
