//
//  CCFFormTree.h
//  CCF
//
//  Created by WDY on 15/12/31.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CCFForm.h"

@interface CCFFormTree : JSONModel


@property (strong, nonatomic) NSArray<CCFForm*>* ccfforms;

-(NSArray<CCFForm>*) filterByCCFUser:(BOOL) logdined;

@end
