//
//  CCFToolbar.m
//  CCF
//
//  Created by 迪远 王 on 16/1/8.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFToolbar.h"

@implementation CCFToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)didMoveToSuperview{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

@end
