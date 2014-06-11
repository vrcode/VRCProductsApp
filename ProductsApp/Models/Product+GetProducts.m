//
//  Product+GetProducts.m
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "Product+GetProducts.h"


@implementation Product (GetProducts)

+ (NSMutableArray *)getProductsFromDatabase:(sqlite3 *)db {
    return [self getProductsFromDatabase:db withRecordId:-1];
}

+ (NSMutableArray *)getProductsFromDatabase:(sqlite3 *)db withRecordId:(long)recordId {

    NSMutableArray *products = nil;

    if (db) {
        sqlite3_stmt *statement = NULL;

        NSString *query =
            @"SELECT "
                "product_id, "
                "product_name, "
                "product_description, "
                "product_regular_price, "
                "product_sale_price, "
                "product_photo, "
                "product_colors, "
                "product_stores "
            "FROM Products ";

        if (recordId >= 0) {
            query = [query stringByAppendingString:@"WHERE product_id = ?"];
        }

        int result = sqlite3_prepare_v2(db, query.UTF8String, -1, &statement, NULL);
        
        if (result == SQLITE_OK) {
            if (recordId >= 0) {
                sqlite3_bind_int64(statement, 1, recordId);
            }

            result = sqlite3_step(statement);
            if (result == SQLITE_ROW) {
                products = [[NSMutableArray alloc] init];

                do {
                    long productId = sqlite3_column_int(statement, 0);
                    // Get Product's record into variables
                    NSString *productName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    NSString *productDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    double productRegularPrice = sqlite3_column_double(statement, 3);
                    double productSalePrice = sqlite3_column_double(statement, 4);

                    // Get Product's Photo data from BLOB
                    const void * productPhotoBlob = sqlite3_column_blob(statement, 5);
                    long productPhotoBlobSize = sqlite3_column_bytes(statement, 5);
                    NSData *productPhotoData = [NSData dataWithBytes:productPhotoBlob length:productPhotoBlobSize];

                    NSString *productColors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];

                    // Get Stores JSON string for Dictionary
                    NSString *productStoresString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    NSData *productStoresData = [productStoresString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *productStores = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:productStoresData options:0 error:nil];

                    // Create Product object for current record
                    Product *product = [[Product alloc] initWithDatabase:db];
                    if (product) {
                        product.productId = productId;
                        product.productName = productName;
                        product.productDescription = productDescription;
                        product.productRegularPrice = productRegularPrice;
                        product.productSalePrice = productSalePrice;
                        product.productImage = [UIImage imageWithData:productPhotoData];
                        if (productColors.length > 0) {
                            product.productColors = [productColors componentsSeparatedByString:@","];
                        } else {
                            product.productColors = @[];
                        }

                        product.productStores = productStores;
                        product.recordNeedsSaving = NO;
                        
                        [products addObject:product];
                    }
                } while (sqlite3_step(statement) == SQLITE_ROW);
            }
        }

        sqlite3_finalize(statement);
        statement = NULL;
    }

    return products;
}


+ (Product *)getProductWithId:(long)productId fromDatabase:(sqlite3 *)db {
    
    Product *product = nil;

    // Returned Array should contain only one record (first element)
    // corresponding to provided Id if it was found
    NSArray *products = [Product getProductsFromDatabase:db withRecordId:productId];
    if (products) {
        product = products[0];
    }

    return product;
}

@end
