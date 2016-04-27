//
//  LoginViewController.m
//  CCF
//
//  Created by WDY on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "LoginViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import <AFImageDownloader.h>
#import<CommonCrypto/CommonDigest.h>
#import<Foundation/Foundation.h>

#import "CCFBrowser.h"
#import "CCFParser.h"
#import "CCFFormTableViewController.h"
#import "AppDelegate.h"

#import "UIStoryboard+CCF.h"
#import "CCFApi.h"
#import <SVProgressHUD.h>
#import "CCFCoreDataManager.h"

@interface LoginViewController ()<UITextFieldDelegate>{

    CCFBrowser *_browser;
    CGRect screenSize;
    
    CCFApi *_ccfApi;
    
    UITextField * currentFocused;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _userName.delegate = self;
    _password.delegate = self;
    
    
    
    _userName.returnKeyType=UIReturnKeyNext;
    _password.returnKeyType=UIReturnKeyDone;
    _password.keyboardType = UIKeyboardTypeASCIICapable;
    
    
    _browser = [[CCFBrowser alloc]init];
    
    screenSize = [UIScreen mainScreen].bounds;
    
    _ccfApi = [[CCFApi alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentFocused = textField;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userName) {
         [_password becomeFirstResponder];
    } else{
//        [self performSelector:@selector(login:)];
        [self login:self];
    }
    return YES;
}


- (void)keyboardWillShow:(id)sender {
    CGRect keyboardFrame;
    //    UIKeyboardBoundsUserInfoKey
    [[[((NSNotification *)sender) userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    CGRect focusedFrame = currentFocused.frame;
    int bottom = focusedFrame.origin.y + CGRectGetHeight(focusedFrame) + self.view.frame.origin.y;
    
    int keyboardTop = CGRectGetHeight(screenSize) - CGRectGetHeight(keyboardFrame);
    
    if (bottom > keyboardTop) {
        // 键盘被挡住了
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y  -=  (bottom - keyboardTop) + 10;
            self.view.frame = frame;
        }];
    }
    
}

-(void)keyboardWillHide:(id)sender{
    CGRect keyboardFrame;
    
    [[[((NSNotification *)sender) userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
 
    
    if (self.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = 0;
            self.view.frame = frame;
        }];
    }
}



- (IBAction)login:(id)sender {
    

    
    NSString *name = _userName.text;
    NSString *password = _password.text;
    
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    
    if ([name isEqualToString:@""] || [password isEqualToString:@""]) {
        
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"\n用户名或密码为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeBlack];
    
    [_ccfApi loginWithName:name andPassWord:password handler:^(BOOL isSuccess, NSString *message) {
        
        [SVProgressHUD dismiss];

        if (isSuccess) {
            
            [self.ccfApi formList:^(BOOL isSuccess, id needInsert) {
                
                if (isSuccess) {
                    CCFCoreDataManager * formManager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryForm];
                    [formManager insertData:needInsert operation:^(NSManagedObject *target, id src) {
                        FormEntry *newsInfo = (FormEntry*)target;
                        newsInfo.formId = [src valueForKey:@"formId"];
                        newsInfo.formName = [src valueForKey:@"formName"];
                        newsInfo.parentFormId = [src valueForKey:@"parentFormId"];
                        newsInfo.isNeedLogin = [src valueForKey:@"isNeedLogin"];
                    }];
                    
                    UIStoryboard *stortboard = [UIStoryboard mainStoryboard];
                    [stortboard changeRootViewControllerTo:kCCFRootController];
                } else{
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    
                    [alert addAction:action];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }

            }];

        } else{
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
}


- (IBAction)refreshDoor:(id)sender {
    
    [_browser refreshVCodeToUIImageView:_doorImageView];
    
}

@end
