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
    //判断是否成功打开
    if (dbrc == SQLITE_OK) {
        NSLog(@"成功打开数据库");
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
    _lblTotalIncome.text = @"2000";
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
    [calendar setFirstWeekday:2];//设定周一为周首日
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

@end
