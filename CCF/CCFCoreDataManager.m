//
//  CCFCoreDataManager.m
//  CCF
//
//  Created by WDY on 16/1/12.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFCoreDataManager.h"
#import "FormEntry.h"
#import "CCFForm.h"

@implementation CCFCoreDataManager

-(instancetype)initWithCCFCoreDataEntry:(CCFCoreDataEntry)enrty{
    if (enrty == CCFCoreDataEntryForm) {
    
        return [self initWithXcdatamodeld:kFormXcda andWithPersistentName:kFormDBName andWithEntryName:kFormEntry];
    } else if (enrty == CCFCoreDataEntryUser){
        
        return [self initWithXcdatamodeld:kFormXcda andWithPersistentName:kFormDBName andWithEntryName:kUserEntry];
    }
    return nil;
    
}


-(NSArray<CCFForm *> *)selectFavForms:(NSArray *)ids{
    
    NSArray<FormEntry *> *entrys = [self selectData:^NSPredicate *{
        return [NSPredicate predicateWithFormat:@"formId IN %@", ids];
    }];
    
    NSMutableArray<CCFForm *> *forms = [NSMutableArray arrayWithCapacity:entrys.count];
    
    for (FormEntry *entry in entrys) {
        CCFForm * form = [[CCFForm alloc] init];
        form.formName = entry.formName;
        
        [forms addObject:form];
        
    }
    return [forms copy];
}




@end
