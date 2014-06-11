//
//  VRCUtilities.m
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCUtilities.h"


@implementation VRCUtilities

+ (NSString *)pathForDocumentsFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex: 0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = (NSDictionary *) [
        NSJSONSerialization
        JSONObjectWithData:jsonData
        options:0
        error:nil
    ];

    return dict;
}

@end
