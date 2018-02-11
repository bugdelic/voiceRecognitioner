//
//  SQLiteManager.m
//  SpeakToMe
//
//  Created by satorupan on 2018/02/11.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//
#import "SQLiteManager.h"

@interface SQLiteManager(){
    
    sqlite3 *database;
    sqlite3_stmt *statement;
}
@property (nonatomic, assign) sqlite3 *database;
@property (nonatomic, assign) sqlite3_stmt *statement;

@end




@implementation SQLiteManager
@synthesize database,statement;

-(id) init
{
    if(self = [super init]){
        
    }
    return self;
}

-(NSDictionary*)fotnSelect:(NSString *)value {
    
    //NSDictionary*returner=[[NSDictionary alloc] init];
    
    NSString *sql=[NSString stringWithFormat:@"select * from fotn where unicode = '%@';",value ];
    
    NSMutableDictionary*myReturn=[[NSMutableDictionary alloc] init];
    NSString *databaseName = @"FOTN.db";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString *path = [paths objectAtIndex:0];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourceDirectoryPath = [bundle bundlePath];
    
    NSString *databasePath = [resourceDirectoryPath stringByAppendingPathComponent:databaseName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // 文章フォルダにデータベースファイルが存在しているかを確認する
    if (![manager fileExistsAtPath:databasePath]) {
        
        // 文章フォルダに存在しない場合は、データベースをコピーする
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        BOOL success = [manager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
        
        if (success) {
            NSLog(@"Database file copied.");
        } else {
            NSLog(@"%@", error);
            return nil;
        }
    } else {
        
        NSLog(@"Database file exist.");
    }
    
    sqlite3 *database;
    sqlite3_stmt *statement;
    
    // 文章フォルダに用意されたデータベースファイルを開く
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        
        // SQLite のコンパイルに失敗した場合
        if (result != SQLITE_OK) {
            NSLog(@"Failed to SQLite compile.");
            return nil;
        }
        // SQL 文を実行し、結果が得られなくなるまで繰り返す
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,0)] forKey:@"id"];
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)] forKey:@"jis"];
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,2)] forKey:@"unicode"];
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,3)] forKey:@"dot"];
            NSLog(@"%@",myReturn);
        }
        
        // データベースを閉じる
        sqlite3_close(database);
    } else {
        
        NSLog(@"Can't open database.");
    }

    return myReturn;
}

+ (id)handleDatabaseWithSql:(NSString *)sql
{
    
    NSMutableDictionary*myReturn=[[NSMutableDictionary alloc] init];
    NSString *databaseName = @"FOTN.db";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *path = [paths objectAtIndex:0];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourceDirectoryPath = [bundle bundlePath];
    
    NSString *databasePath = [resourceDirectoryPath stringByAppendingPathComponent:databaseName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // 文章フォルダにデータベースファイルが存在しているかを確認する
    if (![manager fileExistsAtPath:databasePath]) {
        
        // 文章フォルダに存在しない場合は、データベースをコピーする
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        BOOL success = [manager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
        
        if (success) {
            NSLog(@"Database file copied.");
        } else {
            NSLog(@"%@", error);
            return nil;
        }
    } else {
        
        NSLog(@"Database file exist.");
    }
    
    sqlite3 *database;
    sqlite3_stmt *statement;
    
    // 文章フォルダに用意されたデータベースファイルを開く
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        
        // SQLite のコンパイルに失敗した場合
        if (result != SQLITE_OK) {
            NSLog(@"Failed to SQLite compile.");
            return nil;
        }
        // SQL 文を実行し、結果が得られなくなるまで繰り返す
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)] forKey:@"id"];
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,2)] forKey:@"jis"];
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,3)] forKey:@"utf8"];
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,4)] forKey:@"box"];
            [myReturn setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,5)] forKey:@"description"];
            NSLog(@"%@",myReturn);
        }
        
        // データベースを閉じる
        sqlite3_close(database);
    } else {
        
        NSLog(@"Can't open database.");
    }
    
    return self;
}

@end
