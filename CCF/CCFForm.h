//
//  CCFForm.h
//  CCF
//
//  Created by 迪远 王 on 16/1/23.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFForm : NSObject

@property (nonatomic, assign) int formId;
@property (nonatomic, strong) NSString * formName;
@property (nonatomic, assign) int parentFormId;

@property (nonatomic, strong) NSMutableArray<CCFForm *> * childForms;
@property (nonatomic, assign) int isNeedLogin;

@end
