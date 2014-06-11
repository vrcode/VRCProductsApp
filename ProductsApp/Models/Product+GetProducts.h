//
//  Product+GetProducts.h
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product.h"

/**
    Product object category with class methods that allow
    easy Product(s) retrieval from the database.
 */

@interface Product (GetProducts)

/**
    Returns all the Product records from the database
    as an array of Product objects.

    @param  db  SQLite handle for the Products DB

    @return An array of Product objects for all the
            records in the database
 */

+ (NSMutableArray *)getProductsFromDatabase:(sqlite3 *)db;

/**
    Returns a single Product object for the record corresponding
    the provided Id

    @param  productId   Product Id for Product record to retrieve
    @param  db          Products DB SQLite handle

    @return Product object matching provided record Id or nil
            if not record was found.
 */

+ (Product *)getProductWithId:(long)productId fromDatabase:(sqlite3 *)db;

@end
