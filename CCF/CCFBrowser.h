//
//  CCFBrowser.h
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^success) (id result);


@interface CCFBrowser : NSObject

@property (nonatomic, strong) AFHTTPSessionManager * browser;

-(void) browseWithUrl:(NSURL*) url : (success) callBack ;

-(void) loginWithName:(NSString*)name AndPassword:(NSString*)pwd : (success) callBack;

-(void) logout;

-(void)refreshVCodeToUIImageView:(UIImageView* ) vCodeImageView;


- (NSString *) getCurrentCCFUser;



@end
