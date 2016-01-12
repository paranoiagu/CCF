//
//  UIStoryboard+CCF.h
//  CCF
//
//  Created by WDY on 16/1/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCCFRootController @"CCFNavigationController"

//所有的论坛
#define kCCFFavFormController @"CCFFavFormController"
//收藏的论坛
@interface UIStoryboard(CCF)

+(UIStoryboard *)mainStoryboard;

-(void) changeRootViewControllerTo:(NSString *)identifier;

@end
