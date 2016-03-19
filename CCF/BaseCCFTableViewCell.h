//
//  BaseCCFTableViewCell.h
//  CCF
//
//  Created by 迪远 王 on 16/3/19.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFCoreDataManager.h"
#import "CCFUserEntry+CoreDataProperties.h"
#import "CCFApi.h"
#import <UIImageView+AFNetworking.h>
#import "CCFUrlBuilder.h"

@interface BaseCCFTableViewCell : UITableViewCell

-(void) setData:(id) data;

-(void) showAvatar:(UIImageView *)avatarImageView userId:(NSString*)userId;

@end
