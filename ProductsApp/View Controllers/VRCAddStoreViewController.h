//
//  AddStoreViewController.h
//  ProductsApp
//
//  Created by F on 6/6/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    Protocol for AddStoreViewController delegates.
 */
@protocol AddStoreDelegate <NSObject>

/** Called when the user taps the Save button
    @param storeName    Text entered in Name field
    @param quantity     Number entered in Quanity field
*/

- (void)addStoreWithName:(NSString *)storeName andQuantity:(int)quantity;

@end


/**
    Allows to add Stores to a Product
 */

@interface VRCAddStoreViewController : UITableViewController

/** AddStoreViewController delegate object. Used to
    notify when the user is done entering text and
    tapping the Save button.
 */

@property (nonatomic, weak)     id<AddStoreDelegate>    delegate;

@end
