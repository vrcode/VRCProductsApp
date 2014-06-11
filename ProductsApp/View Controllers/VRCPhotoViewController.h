//
//  PhotoViewController.h
//  ProductsApp
//
//  Created by F on 6/8/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    Displays a full size of the product's photo
 */

@interface VRCPhotoViewController : UIViewController <UIScrollViewDelegate>

/** Image to display */

@property (nonatomic)   UIImage *image;

@end
