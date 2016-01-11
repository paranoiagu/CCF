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



@class CCFShowThread;
@class CCFSearchResultPage;


@interface CCFParser : NSObject


-(CCFShowThread *) parseShowThreadWithHtml:(NSString*)html;


-(NSMutableArray<CCFThreadList*> *) parseThreadListFromHtml: (NSString *) html withThread:(NSString *) threadId andContainsTop:(BOOL)containTop;

-(NSMutableArray<CCFThreadList*> *) parseFavThreadListFormHtml: (NSString *) html;

-(NSString *) parseSecurityToken:(NSString *)html;

- (NSString *) parseLoginErrorMessage:(NSString *)html;

- (NSMutableArray<CCFSearchResultPage*> *) parseSearchPageFromHtml:( NSString*) html;

@end
