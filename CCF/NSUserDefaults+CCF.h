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

#define kCCFInsertAllForms @"InsertAllForms"





@interface NSUserDefaults(CCF)

-(NSString *)loadCookie;

-(void)saveCookie;

-(void) saveFavFormIds:(NSArray*) ids;

-(NSArray *) favFormIds;

-(BOOL) hasInserAllForms;

-(void) setInserAllForms:(BOOL)insert;

-(void) clearCookie;

@end
