//
//  DailyCashViewController.h
//  DailyCash
//
//  Created by luochuanlu on 13-4-27.
//  Copyright (c) 2013年 www.nekaso.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface DailyCashViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalIncome;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalOutcome;

@property (weak, nonatomic) IBOutlet UILabel *lblTodayInAndOutcome;
@property (weak, nonatomic) IBOutlet UILabel *lblWeekInAndOutcome;
@property (weak, nonatomic) IBOutlet UILabel *lblMonthInAndOutcome;
@end
