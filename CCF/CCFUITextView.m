//
//  CCFUITextView.m
//  CCF
//
//  Created by WDY on 16/1/8.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFUITextView.h"

@implementation CCFUITextView{
    UILabel * placeHoler;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        placeHoler = [[UILabel alloc] initWithFrame:self.frame];
        
        [self addSubview:placeHoler];
        placeHoler.text = @" 发表您的态度...";
        placeHoler.font = [UIFont systemFontOfSize:14];
        placeHoler.enabled = NO;

    }
    return self;
}

-(void)textViewDidChange:(UITextView *)textView{

}

-(void)showPlaceHolder:(BOOL)show{
    if (show) {
        placeHoler.text = @" 发表您的态度...";
    } else{
        placeHoler.text = @"";
    }
}




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
