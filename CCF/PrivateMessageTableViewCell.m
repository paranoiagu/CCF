//
//  PrivateMessageTableViewCell.m
//  CCF
//
//  Created by 迪远 王 on 16/3/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "PrivateMessageTableViewCell.h"

@implementation PrivateMessageTableViewCell

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {

        UIEdgeInsets edgeInset =  self.separatorInset;
        edgeInset.left = 40 + 8 + 8;
        [self setSeparatorInset:edgeInset];
        
    }
    return self;
}

-(void)setData:(PrivateMessage *)data{

    
    [self.privateMessageTitle setText:data.pmTitle];
    [self.privateMessageAuthor setText:data.pmAuthor];
    [self.privateMessageTime setText:data.pmTime];
    [self showAvatar:self.privateMessageAuthorAvatar userId:data.pmAuthorId];
    
}
@end
