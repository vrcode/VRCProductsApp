//
//  Product+DeleteProduct.h
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product.h"

/**
    Product category Database record deletions
 */
@interface Product (DeleteProduct)

/**
    Deletes the corresponding record for this instance
    from the database.
 */

- (BOOL)deleteProduct;

@end
