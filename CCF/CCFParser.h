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
#import "FormEntry+CoreDataProperties.h"
#import "CCFFormJSONModel.h"



@class CCFThreadDetail;
@class CCFSearchResultPage;
@class CCFFormJSONModel;

@interface CCFParser : NSObject


- (CCFThreadDetail *) parseShowThreadWithHtml:(NSString*)html;


- (NSMutableArray<CCFThreadList*> *) parseThreadListFromHtml: (NSString *) html withThread:(NSString *) threadId andContainsTop:(BOOL)containTop;

- (NSMutableArray<CCFThreadList*> *) parseFavThreadListFormHtml: (NSString *) html;

- (NSString *) parseSecurityToken:(NSString *)html;

- (NSString *) parsePostHash:(NSString *)html;

- (NSString *) parseLoginErrorMessage:(NSString *)html;

- (CCFSearchResultPage *) parseSearchPageFromHtml:( NSString*) html;

- (NSMutableArray<CCFFormJSONModel *> *) parseFavFormFormHtml:(NSString *)html;

@end
