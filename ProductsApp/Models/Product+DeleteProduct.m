//
//  Product+DeleteProduct.m
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product+DeleteProduct.h"


@implementation Product (DeleteProduct)

- (BOOL)deleteProduct {
    BOOL success = NO;
    const char *query = "DELETE FROM products WHERE product_id = ?";

    sqlite3_stmt *statement = NULL;

    // Prepare Statement
    int result = sqlite3_prepare_v2(self.db, query, -1, &statement, NULL);
    if (result == SQLITE_OK) {
        // Bind productId parameter
        sqlite3_bind_int64(statement, 1, self.productId);

        // Execute Delete Query
        result = sqlite3_step(statement);
        if (result == SQLITE_DONE) {
            success = YES;
            self.productWasDeleted = YES;
        }
        else {
            NSLog(@"Failed to Delete Product Id: %ld - Error: %s", self.recordId, sqlite3_errmsg(self.db));
        }
    }
    else {
        NSLog(@"Failed to prepare Product Delete statement - Error: %s", sqlite3_errmsg(self.db));
    }

    // Clean up
    sqlite3_finalize(statement);
    statement = NULL;

    return success;
}

@end
