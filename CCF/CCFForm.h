//
//  CCFFormTree.h
//  CCF
//
//  Created by WDY on 15/12/31.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFForm : NSObject

@property (nonatomic, assign) int formId;
@property (nonatomic, strong) NSString * formName;
@property (nonatomic, assign) int parentFormId;
@property (nonatomic, strong) NSArray<CCFForm*> * childForms;
@property (nonatomic, assign) int isNeedLogin;


@end