//
//  CCFThreadDetailCell.h
//  CCF
//
//  Created by 迪远 王 on 16/1/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

@class CCFPost;

@interface CCFThreadDetailCell : UITableViewCell



@property (weak, nonatomic) IBOutlet DTAttributedTextView *htmlView;

@property (nonatomic, strong) CCFPost* post;

@end
