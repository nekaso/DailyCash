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
    UIAlertView *alert;
    NSDateFormatter *dateFormatter;
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
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
 
    _txtCashAccount.text = @"0.0";
    _txtCashAccount.keyboardType = UIKeyboardTypeDecimalPad;
    _txtCashAccount.clearsOnBeginEditing = YES;
    
    _txtCategaryName.text = @"Food";
    _txtCategaryName.clearsOnBeginEditing = YES;
    
    _txtDate.text = strDate;
    //_txtDate.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.txtDate.inputView = self.datePickerView;
    //self.customInput.hidden = YES;
    
    //self.txtDate.inputAccessoryView = self.accessoryView;
    //self.accessoryView.hidden = YES;
    
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

    if (dbrc == SQLITE_OK) {
        NSLog(@"Open database successfully!");
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
        alert=[[UIAlertView alloc] initWithTitle:@"Note" message:@"Save is successful!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        
        UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        active.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height-40);
        
        [alert addSubview:active];
        
        [active startAnimating];
        
         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(alertDismiss) userInfo:nil repeats:NO];
        
        [self performSelector:@selector(backToMainPage) withObject:nil afterDelay:0.5];
    }
}

-(void)alertDismiss
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)backToMainPage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)cancelNewItem:(id)sender {
    [self backToMainPage];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.txtCashAccount resignFirstResponder];
    [self.txtCategaryName resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)dateChanged:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    self.txtDate.text = [NSString stringWithFormat:@"%@",
                         [dateFormatter stringFromDate:picker.date]];
}

- (IBAction)doneEditing:(id)sender {
    if (self.txtDate.text.length == 0) {
        self.txtDate.text= [dateFormatter stringFromDate:[NSDate date]];
    }
    [self.txtDate resignFirstResponder];
}

- (IBAction)clickInDateTextFiled:(id)sender {
    //self.customInput.hidden = NO;
    //self.accessoryView.hidden = NO;
}


@end
