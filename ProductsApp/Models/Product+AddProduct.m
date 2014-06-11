//
//  Product+AddProduct.m
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product+AddProduct.h"
#import "Product+UpdateProduct.h"


@implementation Product (AddProduct)

- (void)insertProduct {
    if (self.isNewProduct) {
        Product *temp = [Product
            addProductWithName:self.productName
            andProductDescription:self.productDescription
            inDatabase:self.db
        ];

        self.recordId = self.productId = temp.productId;
        [self updateProduct];
        self.isNewProduct = NO;
        temp = nil;
    }
}

+ (Product *)addProductWithName:(NSString *)productName
   andProductDescription:(NSString *)productDescription
   inDatabase:(sqlite3 *)db {

    Product *product = nil;

    const char *query =
        "INSERT INTO products "
            "(product_name, product_description) "
        "VALUES (?, ?)";

    sqlite3_stmt *statement = nil;

    int result = sqlite3_prepare_v2(db, query, -1, &statement, NULL);

    if (result == SQLITE_OK) {
        // Bind Insert Query values
        sqlite3_bind_text(statement, 1, [productName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [productDescription UTF8String], -1, SQLITE_TRANSIENT);

        result = -1;
        result = sqlite3_step(statement);
        if (result == SQLITE_DONE) {
            product = [[Product alloc] initWithDatabase:db];
            product.productId = (int)sqlite3_last_insert_rowid(db);
            product.productName = productName;
            product.productDescription = productDescription;
            product.productRegularPrice = 0;
            product.productSalePrice = 0;
            product.productImage = nil;
            product.productColors = @[];
            product.productStores = @{};
        }
    }
    else {
        NSLog(@"Error adding product record to Database: %s", sqlite3_errmsg(db));
    }
    
    sqlite3_finalize(statement);
    statement = NULL;

    return product;
}

+ (void)addProductWithDictionary:(NSDictionary *)productDictionary inDatabase:(sqlite3 *)database {
    // Create product record in DB
    Product *product = [Product
        addProductWithName:productDictionary[@"name"]
        andProductDescription:productDictionary[@"description"]
        inDatabase:database
    ];

    // Add details and save
    product.productRegularPrice = ((NSNumber *)productDictionary[@"regular_price"]).doubleValue;
    product.productSalePrice = ((NSNumber *)productDictionary[@"sale_price"]).doubleValue;
    product.productColors = productDictionary[@"colors"];
    product.productStores = productDictionary[@"stores"];

    [product updateProduct];

}

@end
