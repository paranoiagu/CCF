//
//  IGXMLNode+Children.m
//  CCF
//
//  Created by 迪远 王 on 16/3/26.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "IGXMLNode+Children.h"

@implementation IGXMLNode(Children)

-(IGXMLNode *)childrenAtPosition:(int)position{
    return self.children [position];
}

-(int)childrenCount{
    return [self.children count];
}
@end
