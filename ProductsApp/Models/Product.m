//
//  Product.m
//  ProductsApp
//
//  Created by F on 6/5/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//
//
//  TODO:
//      - Add photo thumbnail field so it's faster
//        and more effiecient to load the basic
//        product fields
//


#import "Product.h"


@implementation Product

- (id)initWithDatabase:(sqlite3 *)database {
    self = [super init];

    if (self) {
        self.db = database;
        _productDescription = @"";
        _productRegularPrice = 0;
        _productSalePrice = 0;
        _productImage = nil;
        _productColors = @[];
        _productStores = @{};
    }

    return self;
}

#pragma mark - Getters

- (long)productId {
    return self.recordId;
}

#pragma mark - Setters

- (void)setProductId:(long)productId {
    self.recordId = productId;
}

- (void)setProductName:(NSString *)productName {
    if (![_productName isEqualToString:productName]) {
        _productName = productName;
        self.recordNeedsSaving = YES;
    }
}

- (void)setProductDescription:(NSString *)productDescription {
    if (!_productDescription) {
        _productDescription = productDescription;
    } else if (![_productDescription isEqualToString:productDescription]) {
        _productDescription = productDescription;
        self.recordNeedsSaving = YES;
    }
}

- (void)setProductRegularPrice:(double)productRegularPrice {
    if (_productRegularPrice != productRegularPrice && productRegularPrice >= 0) {
        _productRegularPrice = productRegularPrice;
        self.recordNeedsSaving = YES;
    } else if (productRegularPrice < 0) {
        @throw [self negativePriceException];
    }
}

- (void)setProductSalePrice:(double)productSalePrice {
    if (_productSalePrice != productSalePrice && productSalePrice >= 0) {
        _productSalePrice = productSalePrice;
        self.recordNeedsSaving = YES;
    } else if (productSalePrice < 0) {
        @throw [self negativePriceException];
    }
}

- (void)setProductImage:(UIImage *)productImage {

    if ( ! [_productImage isEqual:productImage]) {
        _productImage = productImage;
        self.recordNeedsSaving = YES;
    }
    
    // TODO:    Keep image hash so it can easily be compared with
    //          new images in order to decide when the record
    //          needs to be updated, so if the image being set
    //          is the same as the current, the record is not
    //          marked for saving unnecessarily
}

- (void)setProductColors:(NSArray *)productColors {
    if (!_productColors) {
        _productColors = productColors;
    } else if (![_productColors isEqual:productColors]) {
        _productColors = productColors;
        self.recordNeedsSaving = YES;
    }
}

- (void)setProductStores:(NSDictionary *)productStores {
    if (!_productStores) {
        _productStores = productStores;
    } else if (![_productStores isEqual:productStores]) {
        _productStores = productStores;
        self.recordNeedsSaving = YES;
    }
}

#pragma mark - Exceptions

- (NSException *)negativePriceException {
    NSException *exception = [NSException
       exceptionWithName:@"NegativePriceException"
       reason:@"The provided price is a negative number"
       userInfo:nil
    ];
    
    return exception;
}

@end
