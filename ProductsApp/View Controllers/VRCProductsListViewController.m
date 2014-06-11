//
//  MasterViewController.m
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCProductsListViewController.h"
#import "VRCProductViewController.h"
#import "Product.h"
#import "Product+AddProduct.h"
#import "Product+GetProducts.h"
#import "Product+DeleteProduct.h"

#import "VRCProductsDatabaseManager.h"


@interface VRCProductsListViewController ()

@property (nonatomic)   sqlite3                 *productsDB;
@property (nonatomic)   Product                 *productForDetails;
@property (nonatomic)   NSIndexPath             *productForDetailsIndexPath;
@property (nonatomic)   VRCProductViewController   *productViewController;

@end

@implementation VRCProductsListViewController

- (void)dealloc {
    [VRCProductsDatabaseManager closeDatabase:_productsDB];
    _productsDB = NULL;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register TableView Cells
    [self.tableView
        registerNib:[UINib nibWithNibName:@"VRCCellLabel" bundle:nil]
        forCellReuseIdentifier:@"VRCCellLabel"
    ];

    // Create and wire "Add" button for adding new products
	UIBarButtonItem *addButton = [
        [UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
        target:self
        action:@selector(addProduct)
    ];
	self.navigationItem.rightBarButtonItem = addButton;

    // Open database and load products
    _productsDB = [VRCProductsDatabaseManager openDatabase];
    _products = [Product getProductsFromDatabase:_productsDB];
}

- (void)viewDidAppear:(BOOL)animated {
    if (_productForDetails) {
        if (_productForDetails.productWasDeleted) {
            [_products removeObjectAtIndex:_productForDetailsIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[_productForDetailsIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (_productForDetails.productWasUpdated) {
            [self.tableView reloadRowsAtIndexPaths:@[_productForDetailsIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (_productForDetails.isNewProduct && _productForDetails.productName.length > 0) {
            [_productForDetails insertProduct];
            [_products addObject:_productForDetails];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_products.count-1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        _productForDetails = nil;
        _productForDetailsIndexPath = nil;
    }
}

#pragma mark - Actions

- (void)addProduct {
    _productForDetails = [[Product alloc] initWithDatabase:_productsDB];

    VRCProductViewController *addProduct = [[VRCProductViewController alloc] initWithStyle:UITableViewStyleGrouped];
    addProduct.title = @"Add Product";
    addProduct.navigationItem.leftBarButtonItem = [
        [UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
        target:self
        action:@selector(dismissPresentedViewController)
    ];
    addProduct.product = _productForDetails;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addProduct];
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)dismissPresentedViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _products.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VRCCellLabel" forIndexPath:indexPath];

    Product *product = _products[indexPath.row];

    cell.imageView.image = product.productImage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

	cell.textLabel.text = product.productName;

    return cell;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;

    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);

    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, newRect, imageRef);

    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];

    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();

    return newImage;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Product *product = _products[indexPath.row];
        if ([product deleteProduct]) {
            [_products removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            // TODO: Display error Alert
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _productForDetails = _products[indexPath.row];
    _productForDetailsIndexPath = indexPath;

    _productViewController = [[VRCProductViewController alloc] init];
    _productViewController.product = _productForDetails;

    [self.navigationController pushViewController:_productViewController animated:YES];
}

@end
