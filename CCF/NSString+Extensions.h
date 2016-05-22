//
//  NSString+Extensions.h
//  DRL
//
//  Created by 迪远 王 on 16/5/21.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

#import<CommonCrypto/CommonDigest.h>

@interface NSString(Extensions)
-(NSString*) replaceUnicode;

-(NSString*) md5HexDigest;


-(NSString*) stringWithRegular:(NSString *) regular;

-(NSString*) stringWithRegular:(NSString *) regular andChild:(NSString *) childRegular;

-(NSString*) trim;

-(NSArray*) arrayWithRegulat:(NSString *) regular;


@end
