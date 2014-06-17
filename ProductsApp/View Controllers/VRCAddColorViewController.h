//
//  AddColorViewController.h
//  ProductsApp
//
//  Created by F on 6/6/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    Protocol for AddColorViewController delegates.
 */

@protocol AddColorDelegate <NSObject>

/** Called when a color is selected
    @param colorSelected    The color that was selected from the list
*/

- (void)addColorColorSelected:(NSString *)colorSelected;

@end


/**
    Allows to add colors to a Product
 */

@interface VRCAddColorViewController : UITableViewController

/** AddColorViewController delegate object. Used to
    notify when a color was selected.
 */

@property (nonatomic, weak)   id<AddColorDelegate> delegate;

@end
