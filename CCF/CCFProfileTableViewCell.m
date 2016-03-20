//
//  CCFProfileTableViewCell.m
//  CCF
//
//  Created by 迪远 王 on 16/3/20.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFProfileTableViewCell.h"

@implementation CCFProfileTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setData:(CCFUserProfile *)data{
    self.profileRank.text = data.profileRank;
    self.profileUserName.text = data.profileName;
    [self showAvatar:self.profileAvatar userId:data.profileUserId];
}

@end
