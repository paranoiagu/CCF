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
#import "AlertProgressViewController.h"
#import "CCFParser.h"
#import "CCFFormTableViewController.h"
#import "AppDelegate.h"

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
    
    
    
    _userName.returnKeyType=UIReturnKeyNext;
    _password.returnKeyType=UIReturnKeyDone;
    _password.keyboardType = UIKeyboardTypeASCIICapable;
    
    
    _browser = [[CCFBrowser alloc]init];
    
    screenSize = [UIScreen mainScreen].bounds;
    
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
    if ([name isEqualToString:@""] || [password isEqualToString:@""]) {
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Default Alert View" message:@"Defalut" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//        [alertView show];
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"\n用户名或密码为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        return;
    }
    
    AlertProgressViewController * progress = [AlertProgressViewController alertControllerWithTitle:@"提示" message:@"\n\n\n正在登录" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:progress animated:YES completion:nil];
    
    
    [_browser loginWithName:name AndPassword:password :^(NSString *result) {
        NSString * userId = [_browser getCurrentCCFUser];
        if (userId != nil) {
            AppDelegate *app = [[UIApplication sharedApplication] delegate];
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"CCFRootController"];
            [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];
            
            [UIView transitionWithView:app.window
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromTop
                            animations:^{ app.window.rootViewController = rootViewController; }
                            completion:nil];
            
        } else{
            CCFParser * parse = [[CCFParser alloc]init];
            NSString * error = [parse parseLoginErrorMessage:result];
            
            [progress dismissViewControllerAnimated:NO completion:nil];
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            
            NSLog(@"loginWithNameloginWithNameloginWithNameloginWithName %@", error);
        }
//        NSLog(@"loginWithNameloginWithNameloginWithNameloginWithName %@", result);
    }];
}


- (IBAction)refreshDoor:(id)sender {
    
    [_browser refreshVCodeToUIImageView:_doorImageView];
    
}

@end
