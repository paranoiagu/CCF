//
//  NSUserDefaults+CCF.m
//  CCF
//
//  Created by WDY on 16/1/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "NSUserDefaults+CCF.h"

#define kCCFCookie @"CCF-Cookies"
#define kCCFFavFormIds @"CCF-FavIds"

#define kCCFInsertAllForms @"InsertAllForms"
#define kUserName @"CCF-UserName"



@implementation NSUserDefaults(CCF)

-(NSString *)loadCookie{
    NSData *cookiesdata = [self objectForKey:kCCFCookie];
    
    
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    

    NSString *result = [[NSString alloc] initWithData:cookiesdata encoding:NSUTF8StringEncoding];

    return result;
}


-(void)saveCookie{
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [self setObject:data forKey:kCCFCookie];
}

-(void)saveFavFormIds:(NSArray *)ids{
    [self setObject:ids forKey:kCCFFavFormIds];
}

-(NSArray *)favFormIds{
    return [self objectForKey:kCCFFavFormIds];
}


-(BOOL)hasInserAllForms{
    return [self boolForKey:kCCFInsertAllForms];
}

-(void)setInserAllForms:(BOOL)insert{
    return [self setBool:insert forKey:kCCFInsertAllForms];
}

-(void)clearCookie{
    [self removeObjectForKey:kCCFCookie];
}


-(void)saveUserName:(NSString *)name{
    [self setValue:name forKey:kUserName];
}

-(NSString*)userName{
    return [self valueForKey:kUserName];
}
@end
