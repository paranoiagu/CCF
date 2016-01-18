//
//  CCFThreadListCell.m
//  CCF
//
//  Created by 迪远 王 on 16/1/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadListCell.h"
#import "CCFThreadList.h"

@implementation CCFThreadListCell

@synthesize threadAuthor = _threadAuthor;
@synthesize threadPostCount = _threadPostCount;
@synthesize threadTitle = _threadTitle;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setThreadList:(CCFThreadList *)threadList{
    self.threadAuthor.text = threadList.threadAuthor;
    self.threadTitle.text = threadList.threadTitle;
    self.threadPostCount.text = [NSString stringWithFormat:@"%ld", threadList.threadTotalPostCount];
}
@end
