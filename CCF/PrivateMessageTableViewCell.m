//
//  PrivateMessageTableViewCell.m
//  CCF
//
//  Created by 迪远 王 on 16/3/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "PrivateMessageTableViewCell.h"

@implementation PrivateMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setData:(PrivateMessage *)data{
    
    NSLog(@"设置 data %@", data);
    [self.privateMessageTitle setText:data.pmTitle];
    [self.privateMessageAuthor setText:data.pmAuthor];
    [self.privateMessageTime setText:data.pmTime];
    
}
@end
