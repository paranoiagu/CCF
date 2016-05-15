//
//  CCFUtils.m
//  CCF
//
//  Created by WDY on 16/1/7.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFUtils.h"

@implementation CCFUtils


+(id)scaleUIImage:(UIImage *)sourceImage andMaxSize:(CGSize)maxSize{
    CGSize size = sourceImage.size;
    
    if (size.height > maxSize.height || size.width > maxSize.width) {
        CGFloat heightScale = maxSize.height / size.height;
        CGFloat widthScale = maxSize.width / size.width;
        
        CGFloat scale = heightScale > widthScale ? widthScale : heightScale;
        
        CGFloat width = size.width;
        CGFloat height = size.height;
        
        CGFloat scaledWidth = width * scale;
        CGFloat scaledHeight = height * scale;
        
        CGSize newSize = CGSizeMake(scaledWidth, scaledHeight);
        UIGraphicsBeginImageContext(newSize);//thiswillcrop
        [sourceImage drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
        UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
        
    } else{
        return sourceImage;
    }
    
}


























@end
