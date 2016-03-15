//
//  CCFSearchResult.h
//  CCF
//
//  Created by WDY on 16/1/11.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFThread.h"

@interface CCFSearchThread : CCFThread

@property (nonatomic, strong) NSString* threadCreateTime;
@property (nonatomic, strong) NSString* threadBelongForm;

@end
