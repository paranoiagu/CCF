//
//  CCFFormTree.m
//  CCF
//
//  Created by WDY on 15/12/31.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "CCFFormTree.h"

@implementation CCFFormTree

-(NSArray<CCFForm*> *)filterByCCFUser:(BOOL)logdined{
    if (_ccfforms == nil) {
        return nil;
    }
    NSMutableArray<CCFForm> * filtered = [NSMutableArray<CCFForm> array];
    
    if (logdined) {
        return _ccfforms;
    }
    
    NSUInteger count = _ccfforms.count;
    
    for (int i = 0; i < count; i++) {
        CCFForm * form = _ccfforms[i];
        if (form.isNeedLogin == 0) {
            [filtered addObject:form];
        }
    }
    
    for (CCFForm * form in filtered) {

        NSMutableArray<CCFForm> *childForms = form.childForms;
        if (childForms != nil && childForms.count > 0) {
            for (CCFForm * child in childForms) {
            
                if (child.isNeedLogin == 1) {
                    [childForms removeObject:childForms];
                }
            }
        }
    }
    
    
    return [filtered copy];
}
@end
