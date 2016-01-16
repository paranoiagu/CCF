//
//  NSUserDefaults+CCF.h
//  CCF
//
//  Created by WDY on 16/1/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kCCFCookie @"CCF-Cookies"
#define kCCFFavFormIds @"CCF-FavIds"





@interface NSUserDefaults(CCF)

-(NSString *)loadCookie;

-(void)saveCookie;

-(void) saveFavFormIds:(NSArray*) ids;

-(NSArray *) favFormIds;

@end
