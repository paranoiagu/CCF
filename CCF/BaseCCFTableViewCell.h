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
#import "CCFUrlBuilder.h"
#import "TransValueUITableViewCell.h"



@interface BaseCCFTableViewCell : TransValueUITableViewCell

-(void) setData:(id) data;

-(void)setData:(id)data forIndexPath:(NSIndexPath *)indexPath;

-(void) showAvatar:(UIImageView *)avatarImageView userId:(NSString*)userId;

@property(nonatomic,weak) NSIndexPath * selectIndexPath;


@end
