//
//  UIImageView+Circle.m
//  CCF
//
//  Created by 迪远 王 on 16/2/28.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "UIImageView+Circle.h"

@implementation UIImageView(Circle)

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.bounds.size.width * 0.5;
        self.layer.borderWidth = 5.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}
@end
