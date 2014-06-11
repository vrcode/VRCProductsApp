//
//  CellPictureSelectorDelegate.h
//  ProductsApp
//
//  Created by F on 6/8/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    Protocol for CellPictureSelector delegates
 */

@protocol VRCCellPictureSelectorDelegate <NSObject>

/**
    Called when the image in the cell has been tapped.
 */

- (void)cellPictureSelectorImageTapped;

/**
    Called when the image has been changed.

    @param image    A reference to the the new image.
 */

- (void)cellPictureSelectorImageChanged:(UIImage *)image;

@end