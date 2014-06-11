//
//  DatabaseRecord.m
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCDatabaseRecord.h"


@implementation VRCDatabaseRecord

- (id)init {
    self = [super init];
    
    if (self) {
        _recordId = 0;
        _db = NULL;
    }
    
    return self;
}

- (BOOL)recordIsReady {
    return (_recordId != 0 && _db != NULL);
}


@end
