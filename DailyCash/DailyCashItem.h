//
//  DailyCashItem.h
//  DailyCash
//
//  Created by luochuanlu on 13-4-27.
//  Copyright (c) 2013年 www.nekaso.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyCashItem : NSObject

@property(nonatomic,strong) NSString *account;
@property(nonatomic,strong) NSString *categaryName;
@property(nonatomic,strong) NSString *recordDate;
@property(nonatomic,strong) NSString *noteText;

@end
