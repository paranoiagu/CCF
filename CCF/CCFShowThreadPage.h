//
//  CCFThread.h
//  CCF
//
//  Created by WDY on 15/12/29.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFPage.h"
#import "CCFPost.h"

@interface CCFShowThreadPage : CCFPage

@property (nonatomic, strong) NSString* threadID;
@property (nonatomic, strong) NSString* threadLink;
@property (nonatomic, strong) NSString * threadTitle;

@end
