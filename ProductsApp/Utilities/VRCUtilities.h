//
//  VRCUtilities.h
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    Misc. Utilities
 */

@interface VRCUtilities : NSObject

/** 
    Returns the full path to the App's Documents directory
    for the specified file

    @param  fileName    File to have prefixed with the App Documents path

    @return A full path to the App Documents folder containing the
            provided file name.
 */

+ (NSString *)pathForDocumentsFile:(NSString *)fileName;

/**
    Converts a JSON string to an NSDictionary

    @param  jsonString  JSON string to convert

    @return NSDictionary with the same structure as the
            provided JSON string
 */

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString;

@end
