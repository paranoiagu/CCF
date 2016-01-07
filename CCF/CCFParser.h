//
//  CCGParser.h
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFPost.h"
#import "CCFUser.h"
#import "CCFThreadList.h"


@interface CCFParser : NSObject

-(NSMutableArray<CCFPost*>*) parsePostFromThreadHtml:(NSString*)html;

-(NSMutableArray<CCFThreadList*> *) parseThreadListFromHtml: (NSString *) html withThread:(NSString *) threadId andContainsTop:(BOOL)containTop;

-(NSString *) parseSecurityToken:(NSString *)html;

@end
