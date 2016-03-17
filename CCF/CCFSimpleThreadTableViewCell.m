//
//  CCFSimpleThreadTableViewCell.m
//  CCF
//
//  Created by WDY on 16/3/17.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSimpleThreadTableViewCell.h"

@implementation CCFSimpleThreadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(CCFSimpleThread *)simpleThread{
    self.threadTitle.text = simpleThread.threadTitle;
    self.threadAuthorName.text = simpleThread.threadAuthorName;
    self.lastPostTime.text = simpleThread.lastPostTime;
    self.threadCategory.text = simpleThread.threadCategory;
}
@end
