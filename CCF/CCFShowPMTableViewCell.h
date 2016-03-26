//
//  CCFShowPMTableViewCell.h
//  CCF
//
//  Created by 迪远 王 on 16/3/26.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>
#import "CCFShowPM.h"

@protocol CCFThreadDetailCellDelegate <NSObject>

@required
-(void) relayoutContentHeigt:(NSIndexPath*) indexPath with:(CGFloat) height;

@end


@interface CCFShowPMTableViewCell : UITableViewCell<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>


@property (weak, nonatomic) IBOutlet DTAttributedTextContentView *htmlView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *postTime;
@property (weak, nonatomic) IBOutlet UILabel *pmTitle;

@property (nonatomic, strong) id<CCFThreadDetailCellDelegate> delegate;

-(void) setData:(CCFShowPM *)privateMessage forIndexPath:(NSIndexPath*)indexPath;

@end
