//
//  Product+UpdateProduct.m
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product+UpdateProduct.h"


@implementation Product (UpdateProduct)

- (BOOL)updateProduct {
    // TODO: Make this run in the background
    BOOL success = NO;
    int result = SQLITE_OK;
    
    if (self.recordIsReady && self.recordNeedsSaving) {
        sqlite3_stmt *statement = NULL;

        const char *query =
            "UPDATE products SET "
                "product_name = ?, "
                "product_description = ?, "
                "product_regular_price = ?, "
                "product_sale_price = ?, "
                "product_photo = ?, "
                "product_colors = ?,"
                "product_stores = ?"
            "WHERE product_id = ?";

        // Prepare statement
        result = sqlite3_prepare_v2(self.db, query, -1, &statement, NULL);
        if (result != SQLITE_OK) {
            NSLog(@"Failed to prepare Update statement - Error: %s", sqlite3_errmsg(self.db));
        }
        else {
            // Bind statement parameters.
            // All String parameters must be marked SQLITE_TRANSIENT so SQLite
            // can handle memory appropriately
            sqlite3_bind_text(statement, 1, [self.productName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [self.productDescription UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_double(statement, 3, self.productRegularPrice);
            sqlite3_bind_double(statement, 4, self.productSalePrice);


            // Prepare Photo data for its BLOB field and bind it
            NSData *productImageData = UIImagePNGRepresentation(self.productImage);
            sqlite3_bind_blob(statement, 5,  productImageData.bytes, (int)productImageData.length, NULL);

            // Convert Colors Array to String and bind it to the statement
            sqlite3_bind_text(statement, 6, [[self.productColors componentsJoinedByString:@","] UTF8String], -1, SQLITE_TRANSIENT);

            // Convert Stores Dictionary to JSON String and bind it to statement
            NSError *error = nil;

            NSData *jsonData = [
                NSJSONSerialization
                dataWithJSONObject:self.productStores
                options:0 //NSJSONWritingPrettyPrinted
                error:&error
            ];
            NSString *productStoresJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            sqlite3_bind_text(statement, 7, [productStoresJSON UTF8String], -1, SQLITE_TRANSIENT);

            // Bind record Id
            sqlite3_bind_int64(statement, 8, self.recordId);

            // Execute Update Query
            result = sqlite3_step(statement);
            if (result == SQLITE_DONE) {
                self.recordNeedsSaving = NO;
                success = YES;
                self.productWasUpdated = YES;
            }
            else {
                NSLog(@"Failed to Update Product Id: %ld - Error: %s", self.recordId, sqlite3_errmsg(self.db));
            }
        }
        sqlite3_finalize(statement);
    }
    return success;
}


@end
