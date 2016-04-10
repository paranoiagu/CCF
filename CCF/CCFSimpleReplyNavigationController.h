//
//  CCFSimpleReplyNavigationController.h
//  CCF
//
//  Created by 迪远 王 on 16/4/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCFThread.h"
#import "CCFShowThreadViewController.h"

@interface CCFSimpleReplyNavigationController : UINavigationController

@property (nonatomic,strong) CCFThread * transThread;
@property (nonatomic, strong) CCFShowThreadViewController * controller;

@end
