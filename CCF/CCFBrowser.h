//
//  CCFBrowser.h
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

@class CCFThreadDetail;



typedef void(^success) (id result);

typedef void (^Reply) (BOOL isSuccess, id result);

typedef void (^CallBack) (NSString* token, NSString * hash, NSString* time );


@interface CCFBrowser : NSObject

@property (nonatomic, strong) AFHTTPSessionManager * browser;

-(void) browseWithUrl:(NSURL*) url : (success) callBack ;

-(void) loginWithName:(NSString*)name AndPassword:(NSString*)pwd : (success) callBack;

-(void) logout;

-(void) refreshVCodeToUIImageView:(UIImageView* ) vCodeImageView;

-(void) reply:(NSString *) threadId :(NSString *) message : (Reply) result;

- (NSString *) getCurrentCCFUser;

- (NSString *) getSessionhash;

- (void) searchWithKeyWord:(NSString*) keyWord searchDone:(success) callback;

-(void)createNewThreadForForm:(NSString *)fId withSubject:(NSString *)subject andMessage:(NSString *)message withImage:(NSData *) image;


@end
