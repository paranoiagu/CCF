//
//  CCFShowPM.h
//  CCF
//
//  Created by 迪远 王 on 16/3/25.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFUser.h"

@interface CCFShowPM : NSObject

@property (nonatomic, strong) CCFUser* pmUserInfo;
@property (nonatomic, strong) NSString* pmID;
@property (nonatomic, strong) NSString* pmTitle;
@property (nonatomic, strong) NSString* pmTime;
@property (nonatomic, strong) NSString* pmContent;

@end
