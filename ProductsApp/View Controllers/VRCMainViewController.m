//
//  MainViewController.m
//  ProductsApp
//
//  Created by F on 6/9/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCMainViewController.h"
#import "VRCProductsListViewController.h"
#import "VRCUtilities.h"
#import "SampleData.h"
#import "Product+AddProduct.h"
#import "VRCProductsDatabaseManager.h"

@interface VRCMainViewController ()

@end

// Enumerations

typedef NS_ENUM(NSInteger, ActionSheetButton) {
    ActionSheetButtonSampleProduct1,
    ActionSheetButtonSampleProduct2,
    ActionSheetButtonSampleProduct3
};

@implementation VRCMainViewController


#pragma mark - Actions

- (IBAction)createProduct:(id)sender {
    UIActionSheet *actionSheet = [
        [UIActionSheet alloc]
        initWithTitle:@"Create Product"
        delegate:self
        cancelButtonTitle:@"Cancel"
        destructiveButtonTitle:nil
        otherButtonTitles:
            @"Sample Product 1",
            @"Sample Product 2",
            @"Sample Product 3",
            nil
    ];

    [actionSheet showInView:self.view];
}

- (IBAction)showProduct:(id)sender {
    VRCProductsListViewController *productsList = [[VRCProductsListViewController alloc] init];
    productsList.title = @"Products";

    [self.navigationController pushViewController:productsList animated:YES];
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	}

    sqlite3 *database = [VRCProductsDatabaseManager openDatabase];

    switch (buttonIndex) {
        case ActionSheetButtonSampleProduct1:
            [Product
                addProductWithDictionary:[VRCUtilities dictionaryWithJSONString:SampleProduct1]
                inDatabase:database
            ];
            break;

        case ActionSheetButtonSampleProduct2:
            [Product
                addProductWithDictionary:[VRCUtilities dictionaryWithJSONString:SampleProduct2]
                inDatabase:database
            ];
            break;

        case ActionSheetButtonSampleProduct3:
            [Product
                addProductWithDictionary:[VRCUtilities dictionaryWithJSONString:SampleProduct3]
                inDatabase:database
            ];
            break;
    }

    [VRCProductsDatabaseManager closeDatabase:database];

}



@end
