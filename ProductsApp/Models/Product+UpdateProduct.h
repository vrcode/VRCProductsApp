//
//  Product+UpdateProduct.h
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product.h"

/**
    Product category for Database record updating
 */

@interface Product (UpdateProduct)

/**
    Writes the record for this instance, but only
    if changes were made and if the record is ready (has a DB handle)
    (@see DatabaseRecord.isRecordReady).
 */

- (BOOL)updateProduct;

@end
