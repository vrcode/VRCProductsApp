//
//  CellPictureSelector.h
//  ProductsApp
//
//  Created by F on 6/8/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRCCellPictureSelectorDelegate.h"

/**
    A custom Table Cell View that that displays an Image or
    allows to select one (if one is not present) by
    handling picture selecting from the Photo Library.
    
    If a picture is present, it provide a detail disclosure
    accessory that when tapped presents an ActionSheet that
    allows to change or remove the picture.
 */

@interface VRCCellPictureSelector : UITableViewCell <
    UIImagePickerControllerDelegate
>

/**
    Delegate object interested being notified about
    changes to the picture.
*/

@property (nonatomic)   UIViewController<VRCCellPictureSelectorDelegate>     *delegate;

/** Picture to display */

@property (nonatomic)   UIImage     *image;

/** Request the Image Picker to be presented */

- (void)presentImagePicker;

@end
