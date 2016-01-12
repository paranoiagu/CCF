//
//  UIStoryboard+CCF.h
//  CCF
//
//  Created by WDY on 16/1/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCCFRootController @"CCFRootController"



@interface UIStoryboard(CCF)

+(UIStoryboard *)mainStoryboard;

-(void) changeRootViewControllerTo:(NSString *)identifier;

@end
