//
//  DailyCashAppDelegate.h
//  DailyCash
//
//  Created by luochuanlu on 13-4-27.
//  Copyright (c) 2013年 www.nekaso.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface DailyCashAppDelegate : UIResponder <UIApplicationDelegate>
{
    sqlite3* database;
}

@property (strong, nonatomic) UIWindow *window;

@end
