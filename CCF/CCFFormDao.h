//
//  CCFFormDao.h
//  CCF
//
//  Created by WDY on 15/12/31.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFFormTreeJSONModel.h"

@interface CCFFormDao : NSObject

-(CCFFormTreeJSONModel *)parseCCFForms:(NSString *)jsonFilePath;


@end
