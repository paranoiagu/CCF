//
//  PrivateMessageInboxPage.h
//  CCF
//
//  Created by 迪远 王 on 16/2/28.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrivateMessage.h"

@interface PrivateMessagePage : NSObject

@property (nonatomic, strong) NSMutableArray<PrivateMessage *> * inboxMessages;

@property (nonatomic, assign) NSUInteger inboxMessageCount;

@property (nonatomic, assign) NSUInteger totalPageCount;

@property (nonatomic, assign) NSUInteger currentPage;

@end
