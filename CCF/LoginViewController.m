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

@interface LoginViewController ()<UITextFieldDelegate>{

    CCFBrowser *_browser;
    CGRect screenSize;
    
    UITextField * currentFocused;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _userName.delegate = self;
    _password.delegate = self;
    
    
    _browser = [[CCFBrowser alloc]init];
    
    screenSize = [UIScreen mainScreen].bounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentFocused = textField;
    
}


- (void)keyboardWillShow:(id)sender {
    CGRect keyboardFrame;
    //    UIKeyboardBoundsUserInfoKey
    [[[((NSNotification *)sender) userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    CGRect focusedFrame = currentFocused.frame;
    CGFloat hideHeight = (focusedFrame.origin.y + CGRectGetHeight(focusedFrame)) - (CGRectGetHeight(screenSize) - CGRectGetHeight(keyboardFrame));
    
    if (hideHeight > 0) {
        // 键盘被挡住了
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y  -= hideHeight + 10;
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
    
    [_browser loginWithName:name AndPassword:password :^(NSString *result) {
        NSLog(@"%@", result);
    }];
}


- (IBAction)refreshDoor:(id)sender {
    
    [_browser refreshVCodeToUIImageView:_doorImageView];
    
}

@end
