//
//  CCFFormDao.m
//  CCF
//
//  Created by WDY on 15/12/31.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "CCFFormDao.h"
#import "CCFFormTreeJSONModel.h"
#import "CCFFormJSONModel.h"
#import "CCFForm.h"

@implementation CCFFormDao


-(NSArray<CCFForm *> *)parseCCFForms:(NSString *)jsonFilePath{
    NSError *error;
    
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:jsonFilePath];
    
    // 系统自带的json解析方法
    //id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    //[jsonObject objectForKey:@"Cameras"];
    
    
    CCFFormTreeJSONModel *formTree = [[CCFFormTreeJSONModel alloc] initWithData:jsonData error:&error];
    
    NSArray<CCFFormJSONModel*> * formModels = formTree.ccfforms;
    
    NSMutableArray<CCFForm*> *forms = [NSMutableArray arrayWithCapacity:formModels.count];
    
    for (CCFFormJSONModel * model in formModels) {
        [forms addObject:[self model2Form:model]];
    }
    
    return [forms copy];
}


-(CCFForm*) model2Form:(CCFFormJSONModel*) model{
    CCFForm * form = [[CCFForm alloc] init];
    form.formId = [[model valueForKey:@"formId"] intValue];
    form.formName = [model valueForKey:@"formName"];
    form.parentFormId = [[model valueForKey:@"parentFormId"] intValue];
    form.isNeedLogin = [[model valueForKey:@"isNeedLogin"] intValue];
    
    NSArray<CCFFormJSONModel*> * childModels = [model valueForKey:@"childForms"];
    
    if (childModels != nil && childModels.count > 0) {
        
        NSMutableArray<CCFForm*> * childForms = [NSMutableArray arrayWithCapacity:childModels.count];
        
        for (CCFFormJSONModel * child in childModels) {

            [childForms addObject:[self model2Form:child]];
        }
        form.childForms = childForms;
    }
    return form;
}

@end
