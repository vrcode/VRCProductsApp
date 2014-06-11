//
//  DatabaseManager.h
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

/**
    A few utility methods to handle opening and closing
    the Products SQLite database. It takes care of creating the database
    if it doesn't exist.
 */

@interface VRCProductsDatabaseManager : NSObject

/**
    Open the Products database

    @return SQLite handle to Products database
 */

+ (sqlite3 *)openDatabase;

/**
    Close previously opened Products database

    @param  db  SQLite handle of previously opened database
 */

+ (void)closeDatabase:(sqlite3 *)db;

@end
