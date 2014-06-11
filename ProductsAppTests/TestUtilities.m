//
//  TestUtilities.m
//  ProductsApp
//
//  Created by F on 6/9/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VRCUtilities.h"
#import "SampleData.h"


@interface TestUtilities : XCTestCase

@end

@implementation TestUtilities

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOne {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex: 0];
//    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)testDictionaryFromProductJSONString {
    NSDictionary *product = [VRCUtilities dictionaryWithJSONString:SampleProduct1];
    
    XCTAssert([product[@"name"] isEqualToString:@"Sample Product 1"], @"Product Name is not the expected value");
    XCTAssert( ! [product[@"name"] isEqualToString:@"Sample Product"], @"Product Name is not the expected value");
    XCTAssertEqual(product[@"regular_price"], @(5), @"Regular Price is not the expected value");
    XCTAssert([product[@"sale_price"] isEqual:@(3.5)], @"Sale Price is not the expected value: %@", product[@"sale_price"]);
    XCTAssert(((NSArray *)product[@"colors"]).count == 1, @"Product Colors doesn't match expected count");
    XCTAssert([product[@"colors"][0] isEqualToString:@"Red"], @"Product Colors doesn't match expected count");
    XCTAssert([product[@"stores"] isKindOfClass:[NSDictionary class]], @"Product Stores is not a Dictionary");
    XCTAssert([product[@"stores"][@"Downtown"] isEqual:@(1)], @"Product Store Downtown Quantity is not the expected value");
}

@end
