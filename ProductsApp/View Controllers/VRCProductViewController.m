//
//  DetailViewController.m
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCProductViewController.h"
#import "Product+DeleteProduct.h"
#import "Product+UpdateProduct.h"
#import "VRCCellLabel.h"
#import "VRCCellTextField.h"
#import "VRCCellNumberField.h"
#import "VRCCellTextView.h"
#import "VRCCellPictureSelector.h"
#import "VRCAddColorViewController.h"
#import "VRCAddStoreViewController.h"
#import "VRCPhotoViewController.h"

@interface VRCProductViewController ()

@property (nonatomic) NSArray               *productFields;
@property (nonatomic) UIBarButtonItem       *barButtonDelete;
@property (nonatomic) UIBarButtonItem       *barButtonSave;

@end

// Enumerations

typedef NS_ENUM(NSInteger, ProductField) {
    ProductPhoto,
    ProductName,
    ProductDescription,
    ProductRegularPrice,
    ProductSalePrice,
    ProductColors,
    ProductStores
};

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeLabel,
    CellTypeTextField,
    CellTypeNumberField,
    CellTypeTextView,
    CellTypeImage
};


typedef NS_ENUM(NSInteger, ActionSheet) {
    ActionSheetDeleteProduct,
    ActionSheetPhotoMenu,
    ActionSheetDeleteProductPhoto
};

typedef NS_ENUM(NSInteger, ActionSheetGenericButton) {
    ActionSheetGenericButtonYes
};


typedef NS_ENUM(NSInteger, ActionSheetPhotoMenuButton) {
    ActionSheetPhotoMenuButtonRemove,
    ActionSheetPhotoMenuButtonChange,
};

@implementation VRCProductViewController

#pragma mark - View Lifecycle

/**
    Configure toolbar for Add or Edit behavior
 */
- (void)configureToolbar {

    if (_product.productName) {
        // Product name exists, we're editing an existing product
        // Add a "Delete" button to toolbar in order to
        // allow to remove Product after confirmation
        _barButtonDelete = [
            [UIBarButtonItem alloc]
            initWithTitle:@"Delete"
            style:UIBarButtonItemStylePlain
            target:self
            action:@selector(deleteProduct)
        ];
        _barButtonDelete.tintColor = [UIColor redColor];

        self.navigationItem.rightBarButtonItem = _barButtonDelete;
    }
    else {
        // Product name is nill, we're creating a new one
        // Add a "Save" button to toolbar, it should be
        // disabled initially and only enabled when a
        // product name is provided
        _barButtonSave = [
            [UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemSave
            target:self
            action:@selector(saveProduct)
        ];
        _barButtonSave.enabled = NO;

        self.navigationItem.rightBarButtonItem = _barButtonSave;
    }
}

/**
    Register all custom cells being used
 */
- (void)registerCustomCells {
    // Default Cell
    [self.tableView
        registerNib:[UINib nibWithNibName:@"VRCCellLabel" bundle:nil]
        forCellReuseIdentifier:@"VRCCellLabel"
    ];

    // A cell with a managed Text Field
    [self.tableView
        registerNib:[UINib nibWithNibName:@"VRCCellTextField" bundle:nil]
        forCellReuseIdentifier:@"VRCCellTextField"
    ];

    // A cell with a managed Text Field configured for numbers use
    [self.tableView
        registerNib:[UINib nibWithNibName:@"VRCCellNumberField" bundle:nil]
        forCellReuseIdentifier:@"VRCCellNumberField"
    ];

    // A cell with a managed Text View, for wrapping long text
    [self.tableView
        registerNib:[UINib nibWithNibName:@"VRCCellTextView" bundle:nil]
        forCellReuseIdentifier:@"VRCCellTextView"
    ];

    // A cell with for the Product's photo
    [self.tableView
        registerNib:[UINib nibWithNibName:@"VRCCellPictureSelector" bundle:nil]
        forCellReuseIdentifier:@"VRCCellPictureSelector"
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Details";

    // Put TableView in editing mode in order to be able to add
    // and remove cells for Colors and Stores
    self.tableView.editing = YES;

    [self registerCustomCells];

    [self configureToolbar];

	if (_product) {
        _productFields = @[
            @"Photo",
            @"Product Name",
            @"Product Description",
            @"Regular Price",
            @"Sale Price",
            @"Colors",
            @"Stores"
        ];
	}
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _productFields.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _productFields[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 1;
    switch (section) {
        case ProductColors:
            rows = _product.productColors.count > 0 ? _product.productColors.count + 1 : 1;
            break;
        case ProductStores:
            rows = _product.productStores.count > 0 ? _product.productStores.count + 1 : 1;
            break;
    }
	return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ProductPhoto:
            return 150;
            break;
        case ProductDescription:
            return 100;
            break;
    }
	return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    NSString *cellText = nil;
    NSString *cellTextPlaceHolder = nil;
    BOOL isPrice = NO;
    
    CellType cellType = CellTypeTextField;
    UIColor *textColor = nil;

    switch (indexPath.section) {
        case ProductPhoto:
            cellType = CellTypeImage;
            break;

        case ProductName:
            cellText = _product.productName;
            cellTextPlaceHolder = NSLocalizedString(@"Enter Product Name", @"Enter Product Name");
            break;

        case ProductDescription:
            cellType = CellTypeTextView;
            cellText = _product.productDescription;
            break;

        case ProductRegularPrice:
            cellType = CellTypeNumberField;
            isPrice = YES;
            cellText = [NSString stringWithFormat:@"%0.2f", _product.productRegularPrice];
            break;

        case ProductSalePrice:
            cellType = CellTypeNumberField;
            isPrice = YES;
            cellText = [NSString stringWithFormat:@"%0.2f", _product.productSalePrice];
            break;

        case ProductColors:
            cellType = CellTypeLabel;

            if (_product.productColors.count == 0 ||
                indexPath.row == _product.productColors.count) {
                cellText = @"Add Color";
                textColor = [UIColor grayColor];
            }
            else {
                cellText = _product.productColors[indexPath.row];
            }
            break;

        case ProductStores:
            cellType = CellTypeLabel;

            if (_product.productStores.count == 0 ||
                indexPath.row == _product.productStores.count) {
                cellText = @"Add Store";
                textColor = [UIColor grayColor];
            }
            else {
                NSString *key = _product.productStores.allKeys[indexPath.row];
                cellText = [NSString stringWithFormat:@"%@: %@", key, _product.productStores[key]];
            }
            break;

    }

    switch (cellType) {
        case CellTypeTextView: {
                VRCCellTextView *cellTextView = [
                    tableView dequeueReusableCellWithIdentifier:@"VRCCellTextView"
                    forIndexPath:indexPath
                ];
                cellTextView.delegate = self;
                cellTextView.textView.text = cellText;
                cell = cellTextView;
                cell.tag = indexPath.section;
            }
            break;

        case CellTypeTextField: {
                VRCCellTextField *cellTextField = [
                    tableView dequeueReusableCellWithIdentifier:@"VRCCellTextField"
                    forIndexPath:indexPath
                ];
                cellTextField.delegate = self;

                cellTextField.textField.placeholder = cellTextPlaceHolder;
                cellTextField.textField.text = cellText;

                cell = cellTextField;
                cell.tag = indexPath.section;
            }
            break;

        case CellTypeNumberField: {
                VRCCellNumberField *cellNumberField = [
                    tableView dequeueReusableCellWithIdentifier:@"VRCCellNumberField"
                    forIndexPath:indexPath
                ];
                cellNumberField.delegate = self;

                cellNumberField.textField.placeholder = cellTextPlaceHolder;
                cellNumberField.textField.text = cellText;

                cell = cellNumberField;
                cell.tag = indexPath.section;
            }
            break;

        case CellTypeLabel: {
                VRCCellLabel *cellLabel = [
                    tableView dequeueReusableCellWithIdentifier:@"VRCCellLabel"
                    forIndexPath:indexPath
                ];
                cellLabel.textLabel.text = cellText;
                cell = cellLabel;

                if (textColor) {
                    cell.textLabel.textColor = textColor;
                }
            }
            break;

        case CellTypeImage: {
                VRCCellPictureSelector *cellPhoto = [
                    tableView dequeueReusableCellWithIdentifier:@"VRCCellPictureSelector"
                    forIndexPath:indexPath
                ];
                cellPhoto.delegate = self;
                cellPhoto.image = _product.productImage;

                cell = cellPhoto;
            }
            break;
    }

    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ProductPhoto) {
        VRCCellPictureSelector *productPhoto = (VRCCellPictureSelector *)[tableView cellForRowAtIndexPath:indexPath];
        if (productPhoto.image) {
            UIActionSheet *actionSheet = [
                [UIActionSheet alloc]
                initWithTitle:@"Product Photo"
                delegate:self
                cancelButtonTitle:@"Cancel"
                destructiveButtonTitle:@"Remove"
                otherButtonTitles:@"Change", nil
            ];
            actionSheet.tag = ActionSheetPhotoMenu;
            [actionSheet showInView:tableView];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ProductColors:
            if (_product.productColors.count == 0 ||
                indexPath.row == _product.productColors.count) {
                return UITableViewCellEditingStyleInsert;
            }
            else {
                return UITableViewCellEditingStyleDelete;
            }
            break;

        case ProductStores:
            if (_product.productStores.count == 0 ||
                indexPath.row == _product.productStores.count) {
                return UITableViewCellEditingStyleInsert;
            }
            else {
                return UITableViewCellEditingStyleDelete;
            }
            break;
    }

    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ProductColors:
        case ProductStores:
            return YES;
            break;
    }

    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ProductColors:
            if (editingStyle == UITableViewCellEditingStyleInsert) {
                // Add color by presenting "Add Color" view controller
                VRCAddColorViewController *addColor = [[VRCAddColorViewController alloc] init];
                addColor.modalPresentationStyle = UIModalPresentationFormSheet;
                addColor.title = @"Add Color";
                addColor.navigationItem.rightBarButtonItem = [
                    [UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                    target:self
                    action:@selector(dismissPresentedViewController)
                ];
                addColor.delegate = self;

                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addColor];
                [self presentViewController:nav animated:YES completion:nil];
            }
            else if (editingStyle == UITableViewCellEditingStyleDelete) {
                // Delete Color
                NSMutableArray *temp = [NSMutableArray arrayWithArray:_product.productColors];
                [temp removeObjectAtIndex:indexPath.row];
                _product.productColors = temp;
                [_product updateProduct];

                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;

        case ProductStores:
            if (editingStyle == UITableViewCellEditingStyleInsert) {
                // Add store thru "Add Store" view controller
                VRCAddStoreViewController *addStore = [[VRCAddStoreViewController alloc] init];
                addStore.modalPresentationStyle = UIModalPresentationFormSheet;
                addStore.title = @"Add Store";
                addStore.navigationItem.leftBarButtonItem = [
                    [UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                    target:self
                    action:@selector(dismissPresentedViewController)
                ];
                addStore.delegate = self;

                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addStore];
                [self presentViewController:nav animated:YES completion:nil];
            }
            else if (editingStyle == UITableViewCellEditingStyleDelete) {
                // Delete Store
                NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:_product.productStores];
                NSString *key = _product.productStores.allKeys[indexPath.row];
                [temp removeObjectForKey:key];
                _product.productStores = temp;
                [_product updateProduct];

                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
    }
}

#pragma mark - Actions

- (void)dismissPresentedViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteProduct {
    UIActionSheet *actionSheet = [
        [UIActionSheet alloc]
        initWithTitle:@"Do you really want to delete this product?"
        delegate:self
        cancelButtonTitle:@"No"
        destructiveButtonTitle:@"Yes"
        otherButtonTitles:nil
    ];
    actionSheet.tag = ActionSheetDeleteProduct;

    [actionSheet showFromBarButtonItem:_barButtonDelete animated:YES];
}

- (void)saveProduct {
    _product.isNewProduct = YES;
    [self dismissPresentedViewController];
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	}

    switch (actionSheet.tag) {
        case ActionSheetDeleteProduct:
            switch (buttonIndex) {
                case ActionSheetGenericButtonYes:
                    // Perform delete, pop back to Products view, remove from array and refresh
                    [_product deleteProduct];
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
            }
            break;

        case ActionSheetPhotoMenu:
            switch (buttonIndex) {
                case ActionSheetPhotoMenuButtonRemove: {
                        UIActionSheet *actionSheet = [
                            [UIActionSheet alloc]
                            initWithTitle:@"Do you really want to remove the Product photo?"
                            delegate:self
                            cancelButtonTitle:@"No"
                            destructiveButtonTitle:@"Yes"
                            otherButtonTitles:nil
                        ];
                        actionSheet.tag = ActionSheetDeleteProductPhoto;

                        [actionSheet showInView:self.tableView];
                    }
                    break;

                case ActionSheetPhotoMenuButtonChange: {
                        VRCCellPictureSelector *productPhoto = (VRCCellPictureSelector *)[
                            self.tableView
                            cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ProductPhoto]
                        ];
                        [productPhoto presentImagePicker];
                    }
                    break;

            }
            break;

        case ActionSheetDeleteProductPhoto:
            switch (buttonIndex) {
                case ActionSheetGenericButtonYes: {
                    // Clear product photo and update database
                        VRCCellPictureSelector *productPhoto = (VRCCellPictureSelector *)[
                            self.tableView
                            cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ProductPhoto]
                        ];
                        productPhoto.image = nil;
                    }
                    break;
            }
            break;

    }
}


#pragma mark - CellTextField Delegate

- (void)cellTextFieldEditingEndedForTag:(NSInteger)tag withText:(NSString *)text {
    switch (tag) {
        case ProductName:
            _product.productName = text;
            if (text.length > 0) {
                _barButtonSave.enabled = YES;
            }
            else {
                _barButtonSave.enabled = NO;
            }
            break;

        case ProductRegularPrice:
            _product.productRegularPrice = text.doubleValue;
            break;

        case ProductSalePrice:
            _product.productSalePrice = text.doubleValue;
            break;
    }
    [_product updateProduct];
}

#pragma mark - CellTextView Delegate

- (void)cellTextViewEditingEndedForTag:(NSInteger)tag withText:(NSString *)text {
    switch (tag) {
        case ProductDescription:
            _product.productDescription = text;
            break;
    }
    [_product updateProduct];
}

#pragma mark - AddColor Delegate

- (void)addColorColorSelected:(NSString *)colorSelected {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_product.productColors];
    [temp addObject:colorSelected];
    _product.productColors = temp;

    [_product updateProduct];

    [self.tableView reloadData];
}

#pragma mark - CellPictureSelector Delegate

- (void)cellPictureSelectorImageChanged:(UIImage *)image {
    _product.productImage = image;
    [_product updateProduct];
}

- (void)cellPictureSelectorImageTapped {
    VRCPhotoViewController *photoView = [[VRCPhotoViewController alloc] init];
    photoView.image = _product.productImage;
    [self.navigationController pushViewController:photoView animated:YES];
}

#pragma mark - AddStore Delegate

- (void)addStoreWithName:(NSString *)storeName andQuantity:(int)quantity {
    NSMutableDictionary *temp = [
        NSMutableDictionary
        dictionaryWithDictionary:_product.productStores
    ];
    [temp setObject:@(quantity) forKey:storeName];
    _product.productStores = temp;

    [_product updateProduct];

    [self.tableView reloadData];
}

@end
