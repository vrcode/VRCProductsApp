//
//  Product+GetProductDetails.h
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product.h"

/**
    Product category methods to load or reload specific
    properties.

    @warning For future use.
 */

@interface Product (LoadProductDetails)

/**
    Load/reload some or all the fields from the database
    for Product object instance
 */

- (BOOL)loadProductDetails;

@end
