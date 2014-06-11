//
//  AddColorViewController.m
//  ProductsApp
//
//  Created by F on 6/6/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCAddColorViewController.h"
#import "VRCCellLabel.h"

@interface VRCAddColorViewController ()

@property (nonatomic)   NSArray     *colors;

@end

@implementation VRCAddColorViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    _colors = @[
        @"Red",
        @"Green",
        @"Blue"
    ];

    [self.tableView
        registerNib:[UINib nibWithNibName:@"CellLabel" bundle:nil]
        forCellReuseIdentifier:@"CellLabel"
    ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLabel" forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = _colors[indexPath.row];

    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate) {
        [_delegate addColorColorSelected:_colors[indexPath.row]];
    }

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
