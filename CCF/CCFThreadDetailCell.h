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



@interface CCFThreadDetailCell : UITableViewCell<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>



@property (weak, nonatomic) IBOutlet DTAttributedTextContentView *htmlView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *louCeng;
@property (weak, nonatomic) IBOutlet UILabel *postTime;

@property (nonatomic, strong) id<CCFThreadDetailCellDelegate> delegate;

-(void) setPost:(CCFPost *)post;


@property (nonatomic, strong) NSURL *lastActionLink;

@property (nonatomic, strong) NSURL *baseURL;

@end
