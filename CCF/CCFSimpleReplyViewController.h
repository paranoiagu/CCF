//
//  CCFSimpleReplyViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/4/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFApiBaseViewController.h"

@interface CCFSimpleReplyViewController : CCFApiBaseViewController

- (IBAction)sendSimpleReply:(id)sender;

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *replyContent;

@end
