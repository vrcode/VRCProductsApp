//
//  PhotoViewController.m
//  ProductsApp
//
//  Created by F on 6/8/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCPhotoViewController.h"


@interface VRCPhotoViewController ()

@end

@implementation VRCPhotoViewController {

    IBOutlet UIImageView *imageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Photo";

    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.delegate = self;
    scrollView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIScrollView *scrollView = (UIScrollView *)self.view;

    imageView.image = _image;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    if (_image.size.width < scrollView.bounds.size.width && _image.size.height < scrollView.bounds.size.height) {
        imageView.contentMode = UIViewContentModeCenter;
    } else {
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);

    CGFloat ratio = _image.size.width / CGRectGetWidth(scrollView.bounds);

    scrollView.contentSize = _image.size;

    scrollView.minimumZoomScale = 1.0;
    scrollView.zoomScale = 1.0;
    scrollView.maximumZoomScale = ratio;
}

- (void)viewDidLayoutSubviews {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = imageView.frame.size;
}

@end
