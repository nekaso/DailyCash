//
//  DailyCashViewController.m
//  DailyCash
//
//  Created by luochuanlu on 13-4-27.
//  Copyright (c) 2013年 www.nekaso.com. All rights reserved.
//

#import "DailyCashViewController.h"
#import "DailyCashSummaryOfMonth.h"

@interface DailyCashViewController ()
{
    sqlite3 *db;
    UIAlertView *alert;
}
@end

@implementation DailyCashViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //Get current month
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"DailyCashDatabase"];
    
    int dbrc;
    dbrc = sqlite3_open([path UTF8String], &db);
    if (dbrc == SQLITE_OK) {
        NSLog(@"Open database successful!");
    }

	sqlite3_stmt *dbps;
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
     
    NSString *queryStatementNS =[NSString stringWithFormat:
    @"select SUM(account) from CASHITEMS where recordDate like \'%@%%\'",strDate];
    NSLog(@"Select: dbrc = %@",queryStatementNS);
    if(sqlite3_prepare_v2(db, [queryStatementNS UTF8String], -1, &dbps, NULL)==SQLITE_OK)
        NSLog(@"select totalOutcome is ok.");
    NSLog(@"Select: queryStatementNS = %@",queryStatementNS);
    NSNumber *totalOutcome;
     while (sqlite3_step (dbps) == SQLITE_ROW)
    {
        totalOutcome = [[NSNumber alloc]initWithDouble:sqlite3_column_double(dbps, 0)];
        NSLog(@"primaryKeyValue = %@",totalOutcome);
    }
    
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter2 stringFromDate:[NSDate date]];
    
    NSString *queryStatementNS2 =[NSString stringWithFormat:
                        @"select SUM(account) from CASHITEMS where recordDate like \'%@%%\'",today];
    NSLog(@"Select: dbrc = %@",queryStatementNS2);
    if(sqlite3_prepare_v2(db, [queryStatementNS2 UTF8String], -1, &dbps, NULL)==SQLITE_OK)
        NSLog(@"select totalAccountOfToday is ok.");
    NSLog(@"Select: queryStatementNS = %@",queryStatementNS2);
    NSNumber *totalAccountOfToday;
    while (sqlite3_step (dbps) == SQLITE_ROW)
    {
        totalAccountOfToday = [[NSNumber alloc]initWithDouble:sqlite3_column_double(dbps, 0)];
        NSLog(@"primaryKeyValue = %@",totalAccountOfToday);
    }
    
    NSString *thisWeek = [self getWeekBeginAndEndWith:nil];
    NSString *queryStatementNS3 =[NSString stringWithFormat:
                                  @"select SUM(account) from CASHITEMS where recordDate %@",thisWeek];
    NSLog(@"Select: dbrc = %@",queryStatementNS3);
    if(sqlite3_prepare_v2(db, [queryStatementNS3 UTF8String], -1, &dbps, NULL)==SQLITE_OK)
        NSLog(@"select totalAccountOfWeek is ok.");
    NSLog(@"Select: queryStatementNS = %@",queryStatementNS3);
    NSNumber *totalAccountOfWeek;
    while (sqlite3_step (dbps) == SQLITE_ROW)
    {
        totalAccountOfWeek = [[NSNumber alloc]initWithDouble:sqlite3_column_double(dbps, 0)];
        NSLog(@"primaryKeyValue = %@",totalAccountOfWeek);
    }
    
    _lblCurrentMonth.text = strDate;
    _lblTotalOutcome.text = [numberFormatter stringFromNumber:totalOutcome];
    _lblTodayInAndOutcome.text = [numberFormatter stringFromNumber:totalAccountOfToday];
    _lblWeekInAndOutcome.text = [numberFormatter stringFromNumber:totalAccountOfWeek];
    _lblMonthInAndOutcome.text = [numberFormatter stringFromNumber:totalOutcome];
    
    
    sqlite3_finalize(dbps);
    
    //sqlite3_close(db);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    sqlite3_close(db);
    
    // Dispose of any resources that can be recreated.
}
 
-  (NSString *) getWeekBeginAndEndWith:(NSDate *)newDate
{
    if (newDate == nil)
    {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//Monday is the first day of each week
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    NSString *dateSpan = [NSString stringWithFormat:@"between \'%@\' and \'%@\'",beginString,endString];
    
    return dateSpan;
}

- (IBAction)GenerateCSVReport:(id)sender {
    NSString *csv = @"Account,CategaryName,RecordDate,NoteText\n";
    
    NSString *fileName = [[self documentsPath] stringByAppendingPathComponent:@"myFile.csv"];
    NSLog(@"%@",fileName);
    
    @try {
        [self writeToFile:csv withFileName:fileName];
    }
    @catch (NSException *exception) {
        NSLog(@"*************Exception: %@", exception);
    }
    @finally {
        
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sqLiteDb = [documentsDirectory stringByAppendingPathComponent:@"DailyCashDatabase"];
    
    @try
    {
    if(sqlite3_open([sqLiteDb UTF8String], &db) == SQLITE_OK)
    {
        const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM CASHITEMS"] UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(db, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                int account = sqlite3_column_int(compiledStatement, 1);
                NSString *categaryName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];  
                NSString *recordDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *noteText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *rowString = [NSString stringWithFormat:@"%d,%@,%@,%@\n",account,categaryName,recordDate,noteText];
                
                [self writeToFile:rowString withFileName:fileName];

            }
            
            sqlite3_finalize(compiledStatement);
            sqlite3_close(db);
            
        }
    }
        else{
            NSLog(@"database error");
        }
    }
    @catch (NSException *ex)
    {
        NSLog(@"Exception: %@", ex);
    }
    
    NSString *fileContent = [self readFromFile:fileName];

    NSLog(@"%@",fileContent);
    
    alert=[[UIAlertView alloc] initWithTitle:@"Note" message:@"Generate report is successful!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
}

- (NSString *) documentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsdir = [paths objectAtIndex:0];
    return documentsdir;
}

- (void) writeToFile:(NSString *)text withFileName:(NSString *)filePath{
	    NSMutableArray *array = [[NSMutableArray alloc] init];
	    [array addObject:text];
	    [array writeToFile:filePath atomically:YES];
}

- (NSString *) readFromFile:(NSString *)filepath{
	    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]){
	        NSArray *content = [[NSArray alloc] initWithContentsOfFile:filepath];
	        NSString *data = [[NSString alloc] initWithFormat:@"%@", [content objectAtIndex:0]];
	        return data;
	    } else {
	        return nil;
	    }
}
@end
