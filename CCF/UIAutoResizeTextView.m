//
//  UIAutoResizeTextView.m
//  CCF
//
//  Created by 迪远 王 on 16/4/24.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "UIAutoResizeTextView.h"

@implementation UIAutoResizeTextView{
    CGRect screenSize;
}

-(void)didMoveToSuperview{
    screenSize = [UIScreen mainScreen].bounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(id)sender {
    
    CGRect keyboardFrame;
    
    
    [[[((NSNotification *)sender) userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.frame;
        float screenHeight = CGRectGetHeight(screenSize);
        
        float keyboardHeight = CGRectGetHeight(keyboardFrame);
        
        float fieldHeight  = screenHeight - 64 - keyboardHeight;
        
        frame.size.height = fieldHeight;
        
        self.frame = frame;
        
    }];
    
}

-(void)keyboardWillHide:(id)sender{
    CGRect keyboardFrame;
    
    [[[((NSNotification *)sender) userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.frame;
        
        float screenHeight = CGRectGetHeight(screenSize);
        
        float fieldHeight  = screenHeight - 64;
        
        frame.size.height = fieldHeight;
        
        self.frame = frame;
        
    }];
    
}
@end
