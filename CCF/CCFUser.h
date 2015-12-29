//
//  CCFUser.h
//  CCF
//
//  Created by WDY on 15/12/29.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFUser : NSObject

@property (nonatomic, assign) NSString* userName;
@property (nonatomic, assign) NSUInteger userID;
@property (nonatomic, assign) NSString* userRank;
@property (nonatomic, assign) NSString* userLink;
@property (nonatomic, assign) NSString* userSignDate;
@property (nonatomic, assign) NSString* userPostCount;
@property (nonatomic, assign) NSString* userSolveCount;

@end
