//
//  Product+AddProduct.h
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product.h"

/**
    A category for the Product object that provides methods
    that handle insertion in the database.
 */

@interface Product (AddProduct)

/**
    Inserts new Product objects flagged as new
    in the database.
 */

- (void)insertProduct;

/**
    A class method that creates a new Product object
    instance and inserts it into the database.

    @param  productName         Name for the Product being added.
    @param  productDescription  Description for the Product being added.
    @param  db                  SQLite handle for the database where the
                                product record should be inserted.
    @return A new Product object successfully inserted in the DB
            with the provided Name and Description
 */

+ (Product *)addProductWithName:(NSString *)productName
          andProductDescription:(NSString *)productDescription
          inDatabase:(sqlite3 *)db;


/**
    Allows to create a new Product instance and insert into the
    database just by providing a dictionary with a structure
    mirroring the Product object.
 */

+ (void)addProductWithDictionary:(NSDictionary *)productDictionary inDatabase:(sqlite3 *)database;

@end
