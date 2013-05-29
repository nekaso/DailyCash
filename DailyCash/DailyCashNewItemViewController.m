//
//  DailyCashNewItemViewController.m
//  DailyCash
//
//  Created by luochuanlu on 13-4-27.
//  Copyright (c) 2013年 www.nekaso.com. All rights reserved.
//

#import "DailyCashNewItemViewController.h"
#import "DailyCashItem.h"
#import "DailyCashDBHelper.h"

@interface DailyCashNewItemViewController ()
{
    sqlite3 *db;
}
@end

@implementation DailyCashNewItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@", strDate);
 
    _txtCashAccount.text = @"0.0";
    _txtCashAccount.keyboardType = UIKeyboardTypeDecimalPad;
    _txtCashAccount.clearsOnBeginEditing = YES;
    //_txtCashAccount.returnKeyType = UIReturnKeyDone;
    
    _txtCategaryName.text = @"Food";
    //_categaryName.keyboardType = UIKeyboardTypeDecimalPad;
    _txtCategaryName.clearsOnBeginEditing = YES;
    //_txtCategaryName.returnKeyType = UIReturnKeyDone;
    
    _txtDate.text = strDate;
    _txtDate.keyboardType = UIKeyboardTypeDecimalPad;
    _txtDate.clearsOnBeginEditing = YES;
    //_txtDate.returnKeyType = UIReturnKeyDone;
    
    _txtNote.text = @"No Comments!";
    _txtNote.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _txtNote.returnKeyType = UIReturnKeyDone;
    _txtNote.clearsContextBeforeDrawing =YES;
	_txtNote.delegate =self;

        
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveItem:(id)sender {
    DailyCashItem *dailyCashItem = [[DailyCashItem alloc] init];
    dailyCashItem.account = _txtCashAccount.text;
    dailyCashItem.categaryName  = _txtCategaryName.text;
    dailyCashItem.recordDate =_txtDate.text;
    dailyCashItem.noteText = _txtNote.text;
    
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
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS CASHITEMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, account double, categaryName TEXT, recordDate date, noteText TEXT)";
    
    dbrc = sqlite3_prepare_v2(db, [sqlCreateTable UTF8String], -1, &dbps, NULL);
    dbrc = sqlite3_step (dbps);
    NSLog(@"1. dbrc = %d",dbrc);
    
    NSString *insertSql = [NSString stringWithFormat:
                           @"insert into \"CASHITEMS\"\
                           (account, categaryName, recordDate, noteText)\
                           values (\"%f\", \"%@\", \"%@\", \"%@\")",
                           [dailyCashItem.account doubleValue],
                           dailyCashItem.categaryName,
                           dailyCashItem.recordDate,
                           dailyCashItem.noteText];
    
    dbrc = sqlite3_prepare_v2(db, [insertSql UTF8String], -1, &dbps, NULL);
    dbrc = sqlite3_step (dbps);
    NSLog(@"insertSql = %@",insertSql);
    NSLog(@"2. dbrc = %d",dbrc);
    if (dbrc == SQLITE_DONE) {
        NSLog(@"insertSql is OK");
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Note" message:@"Save is successful!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
}

- (IBAction)cancelNewItem:(id)sender {
    
    [self performSegueWithIdentifier:@"CancelBackToMainPage" sender:self];
    
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.txtCashAccount resignFirstResponder];
    [self.txtCategaryName resignFirstResponder];
    [self.txtDate resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
