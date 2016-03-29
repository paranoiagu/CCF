//
//  TransValueUITableViewCell.h
//  CCF
//
//  Created by 迪远 王 on 16/3/29.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCFThreadListCellDelegate <NSObject>

@required
-(void) showUserProfile:(NSIndexPath*)indexPath;

@end


@interface TransValueUITableViewCell : UITableViewCell

@property (weak, nonatomic) id<CCFThreadListCellDelegate> delegate;

@end
