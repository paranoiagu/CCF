//
//  PrivateMessageTableViewCell.h
//  CCF
//
//  Created by 迪远 王 on 16/3/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateMessage.h"

@interface PrivateMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *privateMessageTitle;
@property (weak, nonatomic) IBOutlet UILabel *privateMessageAuthor;
@property (weak, nonatomic) IBOutlet UILabel *privateMessageTime;


-(void) setData:(PrivateMessage*) data;
@end
