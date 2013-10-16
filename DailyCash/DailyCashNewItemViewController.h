//
//  DailyCashNewItemViewController.h
//  DailyCash
//
//  Created by luochuanlu on 13-4-27.
//  Copyright (c) 2013年 www.nekaso.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "DailyCashViewController.h"

@interface DailyCashNewItemViewController : UIViewController<UITextViewDelegate> 

@property (weak, nonatomic) IBOutlet UITextField *txtCashAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtCategaryName;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextView *txtNote;

@property (nonatomic, retain) IBOutlet UIToolbar *accessoryView;
@property (nonatomic, retain) IBOutlet UIDatePicker *customInput;

- (IBAction)saveItem:(id)sender;
- (IBAction)cancelNewItem:(id)sender;
- (IBAction)dateChanged:(id)sender;
- (IBAction)doneEditing:(id)sender;
- (IBAction)clickInDateTextFiled:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;

@end
