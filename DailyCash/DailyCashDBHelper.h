//
//  DailyCashDBHelper.h
//  DailyCash
//
//  Created by luochuanlu on 13-4-27.
//  Copyright (c) 2013年 www.nekaso.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DailyCashDBHelper : NSObject
@property(nonatomic)sqlite3*    m_sql;
@property(nonatomic,retain)NSString*    m_dbName;
-(id)initWithDbName:(NSString*)dbname;
-(BOOL)openOrCreateDatabase:(NSString*)DbName;
-(BOOL)createTable:(NSString*)sqlCreateTable;
-(void)closeDatabase;
-(BOOL)InsertTable:(NSString*)sqlInsert;
-(BOOL)UpdataTable:(NSString*)sqlUpdata;
-(NSArray*)querryTable:(NSString*)sqlQuerry;
-(NSArray*)querryTableByCallBack:(NSString*)sqlQuerry;
@end
