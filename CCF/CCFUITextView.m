//
//  CCFUITextView.m
//  CCF
//
//  Created by WDY on 16/1/8.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFUITextView.h"

@implementation CCFUITextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setContentSize:(CGSize)contentSize{
    
    CGSize orgSize = self.contentSize;
    [super setContentSize:contentSize];
    
    if (self.contentSize.height > kMaxHeight || self.contentSize.height < kMiniHeight) {
        return;
    }
    
    if (orgSize.height != self.contentSize.height) {
        CGRect newFream = self.frame;
        
        newFream.size.height = self.contentSize.height;
        self.frame = newFream;
        if ([self.heightDelegate respondsToSelector:@selector(heightChanged:)]) {
            [self.heightDelegate heightChanged:self.contentSize.height];
        }
    }
}

@end
