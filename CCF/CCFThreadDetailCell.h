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



@protocol CCFThreadDetailCellDelegate <NSObject>

@required
-(void) relayoutContentHeigt:(NSIndexPath*) indexPath with:(CGFloat) height;

@end







@interface CCFThreadDetailCell : UITableViewCell



@property (weak, nonatomic) IBOutlet DTAttributedTextContentView *htmlView;

@property (nonatomic, strong) id<CCFThreadDetailCellDelegate> delegate;

@property (nonatomic, strong) CCFPost* post;

-(void) setPost:(CCFPost *)post with:(NSIndexPath*) indexPath;

@end
