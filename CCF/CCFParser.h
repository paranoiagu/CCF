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


@interface CCFParser : NSObject

-(NSMutableArray<CCFPost*>*) parsePostFromThreadHtml:(NSString*)html;

@end
