//
//  IGXMLNode+Children.h
//  CCF
//
//  Created by 迪远 王 on 16/3/26.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <IGHTMLQuery/IGHTMLQuery.h>

@interface IGXMLNode(Children)

-(IGXMLNode*) childrenAtPosition:(int)position;

- (int) childrenCount;
@end
