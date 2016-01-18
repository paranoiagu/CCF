//
//  CCFThreadListCell.h
//  CCF
//
//  Created by 迪远 王 on 16/1/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCFThreadList;

@interface CCFThreadListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *threadAuthor;

@property (weak, nonatomic) IBOutlet UILabel *threadTitle;

@property (weak, nonatomic) IBOutlet UILabel *threadPostCount;

-(void) setThreadList:(CCFThreadList *) threadList;

@end
