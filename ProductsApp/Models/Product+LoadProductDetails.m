//
//  Product+GetProductDetails.m
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product+LoadProductDetails.h"


@implementation Product (LoadProductDetails)

- (BOOL)loadProductDetails {
    // TODO:    Add bit-field argument that allows
    //          to specify which fields specifically
    //          should be loaded
    BOOL loaded = NO;


    if (self.db) {
        sqlite3_stmt *statement = NULL;

        int result = sqlite3_prepare_v2(
            self.db,
            "SELECT "
                "product_regular_price, "
                "product_sale_price, "
                "product_colors, "
                "product_stores "
            "FROM Products "
            "WHERE product_id = ?",
            -1,
            &statement,
            NULL
        );
        
        if (result == SQLITE_OK) {
            // Bind record Id
            sqlite3_bind_int64(statement, 1, self.recordId);

            // Execute Query
            result = sqlite3_step(statement);

            if (result == SQLITE_ROW) {

                double productRegularPrice = sqlite3_column_double(statement, 0);
                double productSalePrice = sqlite3_column_double(statement, 1);

                NSString *productColors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];

                // Get Stores JSON string for Dictionary
                NSString *productStoresString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSData *productStoresData = [productStoresString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *productStores = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:productStoresData options:0 error:nil];

                // Populate remaining object properties
                self.productRegularPrice = productRegularPrice;
                self.productSalePrice = productSalePrice;
                if (productColors.length > 0) {
                    self.productColors = [productColors componentsSeparatedByString:@","];
                } else {
                    self.productColors = @[];
                }
                self.productStores = productStores;
                self.recordNeedsSaving = NO;

                loaded = YES;
            }
        }
        
        sqlite3_finalize(statement);
        statement = NULL;
    }

    return loaded;
}

@end
