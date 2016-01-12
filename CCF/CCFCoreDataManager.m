//
//  CCFCoreDataManager.m
//  CCF
//
//  Created by WDY on 16/1/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFCoreDataManager.h"

@implementation CCFCoreDataManager

-(instancetype)initWithCCFCoreDataEntry:(CCFCoreDataEntry)enrty{
    
    return [self initWithXcdatamodeld:kFormXcda andWithPersistentName:kFormDBName andWithEntryName:kFormEntry];
}
@end
