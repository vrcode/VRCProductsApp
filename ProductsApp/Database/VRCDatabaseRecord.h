//
//  DatabaseRecord.h
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>


/**
    A generic object to represent a base database record
 */

@interface VRCDatabaseRecord : NSObject

/** Record's table identifier */

@property (nonatomic, assign) long recordId;

/** SQLite handle to record's database */

@property (nonatomic) sqlite3 *db;

/**
    Flag to keep track of when the records needs to be
    written to the database. It must be set to YES
    when a field in the record has been changed.
 */

@property (nonatomic, assign) BOOL recordNeedsSaving;

/**
    Indicates that a record is ready to be used making
    sure its identifier isn't 0 and that it has a DB reference.
 */

- (BOOL)recordIsReady;

@end
