//
//  AddStoreViewController.m
//  ProductsApp
//
//  Created by F on 6/6/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCAddStoreViewController.h"
#import "VRCCellTextField.h"

@interface VRCAddStoreViewController ()

@property (nonatomic)   NSArray     *sections;
@end

typedef NS_ENUM(NSInteger, StoreSection) {
    StoreSectionName,
    StoreSectionQuantity
};

@implementation VRCAddStoreViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    _sections = @[
        @"Store Name",
        @"Quantity",
    ];

    [self.tableView
        registerNib:[UINib nibWithNibName:@"VRCCellTextField" bundle:nil]
        forCellReuseIdentifier:@"VRCCellTextField"
    ];

    self.navigationItem.rightBarButtonItem = [
        [UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemSave
        target:self
        action:@selector(addStore)
    ];

}

#pragma mark - Actions

- (void)addStore {
    if (_delegate) {
        VRCCellTextField *cell = (VRCCellTextField *) [
            self.tableView
            cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:StoreSectionName]
        ];
        NSString *storeName = cell.textField.text;

        cell = (VRCCellTextField *) [
            self.tableView
            cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:StoreSectionQuantity]
        ];
        int quantity = cell.textField.text.intValue;

        [_delegate addStoreWithName:storeName andQuantity:quantity];
    }

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sections[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VRCCellTextField *cell = [tableView dequeueReusableCellWithIdentifier:@"VRCCellTextField" forIndexPath:indexPath];

    cell.textField.text = @"";
    
    return cell;
}

@end
