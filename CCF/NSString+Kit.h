//
//  NSString.h
//  CCF
//
//  Created by 迪远 王 on 15/12/31.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<CommonCrypto/CommonDigest.h>

@interface NSString(Kit)



-(NSString*) replaceUnicode;

-(NSString*) md5HexDigest;


@end
