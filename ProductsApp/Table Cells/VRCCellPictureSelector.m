//
//  CellPictureSelector.m
//  ProductsApp
//
//  Created by F on 6/8/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCCellPictureSelector.h"


@interface VRCCellPictureSelector ()

@property (nonatomic) IBOutlet UIImageView *pictureView;
@property (nonatomic) IBOutlet UILabel *pictureLabel;

@end

@implementation VRCCellPictureSelector

- (void)awakeFromNib {
    // Gesture for handling taps for the image/cell
    UITapGestureRecognizer *tap = [
        [UITapGestureRecognizer alloc]
        initWithTarget:self
        action:@selector(imageTapped:)
    ];
    [self addGestureRecognizer:tap];
}

#pragma mark - Getters

- (UIImage *)image {
    return _pictureView.image;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
    if (image) {
        [_pictureLabel removeFromSuperview];
        self.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    else {
        [self addSubview:_pictureLabel];
        self.accessoryType = UITableViewCellAccessoryNone;
    }

    _pictureView.image = image;
    // Notify Delegate that image has been changed
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(cellPictureSelectorImageChanged:)]) {
            [_delegate cellPictureSelectorImageChanged:image];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEditing:(BOOL)editing {
    [super setEditing:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:NO animated:NO];
}

#pragma mark - Actions

- (void)presentImagePicker {
    // Present Image Picker
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = type;
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:type];
    __weak id weakSelf = self;
    imagePicker.delegate = weakSelf;
    imagePicker.modalPresentationStyle = UIModalPresentationFormSheet;

    [_delegate presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imageTapped:(id)sender {
    if (_pictureView.image) {
        // Display image in larger view
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(cellPictureSelectorImageTapped)]) {
                [_delegate cellPictureSelectorImageTapped];
            }
        }
    } else {
        [self presentImagePicker];
    }
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {

	UIImage* image = info[UIImagePickerControllerOriginalImage];
    [self setImage:image];
	[_delegate dismissViewControllerAnimated:YES completion:nil];
}

@end
