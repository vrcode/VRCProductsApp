//
//  DatabaseManager.m
//  ProductsApp
//
//  Created by F on 6/4/14.
//  Copyright (c) 2014 VRCode. All rights reserved.
//

#import "VRCProductsDatabaseManager.h"
#import "VRCUtilities.h"



static NSString * const VRCProductsDatabaseName = @"products.db";

@implementation VRCProductsDatabaseManager

+ (void)createDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *dbPath = [VRCUtilities pathForDocumentsFile:VRCProductsDatabaseName];

    // If the database file is not found a new one is created
    if (![fileManager fileExistsAtPath:dbPath]) {
        sqlite3 *db = [self getDatabaseInstance];

        if (db) {
            // Create database using the current schema
            NSString *schemaPath = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"sql"];

            if ([fileManager fileExistsAtPath:schemaPath]) {
                
                NSString *schema = [
                    NSString stringWithContentsOfFile:schemaPath
                    encoding:NSASCIIStringEncoding
                    error:NULL
                ];

                char *error = NULL;
                
                // Execute SQL commands
                int result = sqlite3_exec(db, schema.UTF8String, NULL, NULL, &error);

                if (result == SQLITE_OK) {
                    NSLog(@"Products Database created successfully");
                }
            }
            
            [self closeDatabase:db];
        }
    }

}

+ (sqlite3 *)openDatabase {
    [VRCProductsDatabaseManager createDatabaseIfNeeded];
    return [VRCProductsDatabaseManager getDatabaseInstance];
}

+ (sqlite3 *)getDatabaseInstance {
    sqlite3 *db = NULL;
    NSString *dbPath = [VRCUtilities pathForDocumentsFile:VRCProductsDatabaseName];
    
    // Open Database, create if it doesn't exist
    int result = sqlite3_open_v2(
        dbPath.UTF8String,
        &db,
        SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE,
        NULL
    );
    
    if (result != SQLITE_OK) {
        NSLog(@"Error opening Database: %s", sqlite3_errmsg(db));
        sqlite3_close(db);
        db = NULL;
    }

    return db;
}


+ (void)closeDatabase:(sqlite3 *)db {
    if (db) {
        if (sqlite3_close(db) != SQLITE_OK ) {
            NSLog(@"Error closing Database: %s", sqlite3_errmsg(db));
        }
        db = NULL;
    }
}

@end
