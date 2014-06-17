//
//  Product.h
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VRCDatabaseRecord.h"



/**
    The base Product object class.
 */
@interface Product : VRCDatabaseRecord

/** Product Identifier corresponding to the record Id
    in the products table
 */

@property (nonatomic)			long				productId;

/** The name of the product */

@property (nonatomic, copy)		NSString			*productName;

/** A detailed description for the product */

@property (nonatomic, copy)		NSString			*productDescription;

/** Product's regular price */

@property (nonatomic)			double              productRegularPrice;

/** Product's sale price */

@property (nonatomic)			double              productSalePrice;

/** Photo of the product */

@property (nonatomic)			UIImage				*productImage;

/** An array of NSStrings for all the available colors
    for the product
 */

@property (nonatomic)			NSArray				*productColors;

/** A dictionary with all the the stores where the product
    is available, where the key is the store name, and value
    is the quantity of units available at that store.
 */

@property (nonatomic)			NSDictionary		*productStores;

/** Flag to indicate that the Product's record has been written successfully
    to the database.
    
    This is used in VRCProductsList to find out if the a Product that
    pushed to the details view has been modified, so the row for that
    Product is refreshed in order to reflect any changes like name or
    photo change.
 */

@property (nonatomic)           BOOL                productWasUpdated;

/** Flag to indicate that the Product's record has been deleted
    successfully from the database.
    
    This is used in VRCProductsList to find out if the a Product that
    pushed to the details view has been delete, so the row is removed
    once the view is shown.
 */

@property (nonatomic)           BOOL                productWasDeleted;

/**
    Flags object as a new Product, enabling it to be inserted
    in the database.
    
    Used to find out if a product was actually added after
    the "Add Product" view is dismissed.
 */

@property (nonatomic)           BOOL                isNewProduct;


/**
    Initializes a new Product object with a reference to
    an existing SQLite database.

    @param database A handle to a SQLite database.
 */

- (id)initWithDatabase:(sqlite3 *)database;

@end
