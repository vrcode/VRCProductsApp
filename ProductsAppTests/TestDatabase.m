//
//  ProductsAppTests.m
//  ProductsAppTests
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VRCProductsDatabaseManager.h"
#import "Product+AddProduct.h"
#import "Product+GetProducts.h"
#import "Product+LoadProductDetails.h"
#import "Product+UpdateProduct.h"
#import "Product+DeleteProduct.h"


@interface TestDatabase : XCTestCase

@end

@implementation TestDatabase {
    sqlite3         *_database;
    NSMutableArray  *_tempRecords;
}

- (void)setUp {
    [super setUp];
    _database = [VRCProductsDatabaseManager openDatabase];
    _tempRecords = [[NSMutableArray alloc] init];
}

- (void)tearDown {
    // Delete any records created temporarily
    [_tempRecords makeObjectsPerformSelector:@selector(deleteProduct)];
    [VRCProductsDatabaseManager closeDatabase:_database];
    [super tearDown];
}

- (void)testAddProducts {

    Product *product = [self createTempProduct];

    // Verify Product Id > 0
    XCTAssert(product.productId > 0, @"Product's Id is not > 0 - Returned Id: %ld", product.productId);

    // Verify Product Colors Array is initially empty
    XCTAssertEqual(product.productColors, @[], @"Product Colors is not Nil");

    // Load Product details and verify properties are set
    [product loadProductDetails];
    XCTAssertNotNil(product.productColors, @"Product Colors is Nil after loading details");
    XCTAssert(
        product.productColors.count == 0,
        @"Product Colors count is different than 0 - Actual Count: %lu",
        (unsigned long)product.productColors.count
    );
}

- (void)testGetProducts {
    NSMutableArray *products = [Product getProductsFromDatabase:_database];

    if (products.count == 0) {
        [self createTempProduct];
        products = [Product getProductsFromDatabase:_database];
    }

    XCTAssertFalse(products.count == 0, @"At least one product should have been returned from the Database");
    for (Product *product in products) {
        NSLog(@"Product: %@", product.productName);
        
        // Verify "recordNeedsSaving" flag is false for each record
        XCTAssertFalse(product.recordNeedsSaving, @"Product recrodNeedsSaving is true after being retrieved");
    }

}

- (void)testGetProductWithId {
    Product *product = [self createTempProduct];
    long recordId = product.recordId;
    
    product = [Product getProductWithId:recordId fromDatabase:_database];

    // Verify retrived Product Id is the same as the created one
    XCTAssert(
        product.productId == recordId,
        @"Original productId dosn't match retrieved productId - recordId: %ld, productId: %ld",
        recordId,
        product.productId
    );

    // Verify "recordNeedsSaving" flag is false
    XCTAssertFalse(product.recordNeedsSaving, @"Product recrodNeedsSaving is true after being retrieved");
}

- (void)testUpdateProducts {
    Product *product = [self createTempProduct];

    // ###############################################
    // ##  Verify Update Process for Regular Price  ##
    // ###############################################
    product.productRegularPrice = 123.45;
    // Verify the "recordNeedsSaving" flag is true
    XCTAssertTrue(product.recordNeedsSaving, @"Product's needsSaving flag was not set");
    [product updateProduct];
    // Verify "recordNeedsSaving" flag was reset
    XCTAssertFalse(product.recordNeedsSaving, @"Product's needsSaving flag was not reset");

    // ################################################
    // ##  Verify Update Process for Product Colors  ##
    // ################################################
    product.productColors = @[@"Red", @"Green", @"Blue"];
    // Verify the "recordNeedsSaving" flag is true
    XCTAssertTrue(product.recordNeedsSaving, @"Product's needsSaving flag was not set");
    [product updateProduct];
    // Verify "recordNeedsSaving" flag was reset
    XCTAssertFalse(product.recordNeedsSaving, @"Product's needsSaving flag was not reset");

    // Reload record from DB after writing and verify changes
    product.productRegularPrice = 0; // Setting regular price to 0 to verify value is retrieved from DB
    product.productColors = @[];
    product.recordNeedsSaving = NO; // Reset "needsSaving" flag as this change should be written

    [product loadProductDetails];

    // Regular price must be the same as the one set above
    XCTAssert(
        product.productRegularPrice == 123.45,
        @"Expected Regular Price was not retrieved successfully - "
        @"Actual value: %f",
        product.productRegularPrice
    );

    // Colors must be: @[@"Red", @"Green", @"Blue"]
    XCTAssert(
        ([product.productColors isEqual:@[@"Red", @"Green", @"Blue"]]),
        @"Colors don't match after Update - "
        @"Actual value: %@",
        product.productColors
    );

}

- (void)testDeleteProducts {
    Product *product = [self createTempProduct];
    long recordToDeleteId = product.recordId;

    if ([product deleteProduct]) {
        [_tempRecords removeObject:product];

        // Try to load deleted record with the Id it was created,
        // verify that no record is returned to show that the record
        // was properly deleted
        product = [Product getProductWithId:recordToDeleteId fromDatabase:_database];
        XCTAssertNil(product, @"Product was not properly deleted, a record with the creation Id was returned");
    } else {
        XCTAssert(NO, @"Product record deletion was not successful");
    }
}

- (Product *)createTempProduct {
    NSString *productName = @"Test Product";
    NSString *productDescription = @"A test product added from the test suite";

    Product *product = [
        Product
        addProductWithName:productName
        andProductDescription:productDescription
        inDatabase:_database
    ];

    if (product) {
        XCTAssert(product.productId > 0, @"Temp record was not created successfully");
        [_tempRecords addObject:product];
    } else {
        XCTAssertNil(product, @"Product object wasn't created successfully");
    }

    return product;
}

@end
