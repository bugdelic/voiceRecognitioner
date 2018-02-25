//
//  SQLiteManager.h
//  SpeakToMe
//
//  Created by satorupan on 2018/02/11.
//  Copyright © 2018年 Henry Mason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteManager : NSObject
{
    
}
+ (id)handleDatabaseWithSql:(NSString *)sql;

-(NSDictionary*)fotnSelect:(NSString *)value;

@end
