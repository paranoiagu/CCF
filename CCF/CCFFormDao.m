//
//  CCFFormDao.m
//  CCF
//
//  Created by WDY on 15/12/31.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "CCFFormDao.h"
#import "CCFFormTree.h"

@implementation CCFFormDao

-(CCFFormTree *)parseCCFForms:(NSString *)jsonFilePath{
    NSError *error;
    
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:jsonFilePath];
    
    // 系统自带的json解析方法
    //id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    //[jsonObject objectForKey:@"Cameras"];
    CCFFormTree *forms = [[CCFFormTree alloc] initWithData:jsonData error:&error];
    
    
    return forms;
    
}

@end
