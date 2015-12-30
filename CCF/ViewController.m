//
//  ViewController.m
//  CCF
//
//  Created by WDY on 15/12/28.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <IGHTMLQuery.h>
#import "CCFUser.h"
#import "CCFPost.h"
#import "CCFThread.h"

#import "LoginViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    

    [manager GET:@"https://bbs.et8.net/bbs/showthread.php?t=1331214" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        html = [self replaceUnicode:html];
        
        [self parseThreadInfo:html];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
    }];
    
    
}


-(NSMutableArray*) parseThreadInfo:(NSString*) html{
    NSMutableArray * posts = [NSMutableArray array];
    
    NSLog(@"================= start");
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath:@"//div[@id='posts']/div[*]/div/div/div/table/tr[1]"];
    
    for (int i = 0; i < contents.count; i++) {
        IGXMLNode * postNode = contents[i];
        
        
        
        
        
        CCFUser* ccfuser = [[CCFUser alloc]init];
        
        IGXMLNode * userInfoNode = postNode.firstChild;
        IGXMLNode *nameNode = userInfoNode.firstChild.firstChild;
        
        NSString *name = nameNode.innerHtml;
        ccfuser.userName = name;
        NSString *nameLink = [nameNode attribute:@"href"];
        ccfuser.userLink = [@"https://bbs.et8.net/bbs/" stringByAppendingString:@"member.php?u=70961"];
        ccfuser.userID = [nameLink componentsSeparatedByString:@"member.php?u="].firstObject;
        //avatar
        IGXMLNode * avatarNode = userInfoNode.children[1];
        NSString * avatarLink = [[[avatarNode children] [1] firstChild] attribute:@"src"];
        ccfuser.userAvatar = avatarLink;
        
        //rank
        IGXMLNode * rankNode = userInfoNode.children[3];
        ccfuser.userRank = rankNode.text;
        // 资料div
        IGXMLNode * subInfoNode = userInfoNode.children[4];
        // 注册日期
        IGXMLNode * signDateNode = [[subInfoNode children][1] children] [1];
        ccfuser.userSignDate = signDateNode.text;
        // 帖子数量
        IGXMLNode * postCountNode = [[subInfoNode children][1] children] [2];
        ccfuser.userPostCount = postCountNode.text;
        // 精华 解答 暂时先不处理
        //IGXMLNode * solveCountNode = subInfoNode;
        
        
        
        
        
        IGXMLNode * postInfoNode = [postNode children][1];
        
        NSString* trimString = [postInfoNode.firstChild.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSMutableArray * infos = [NSMutableArray array];
        
        NSArray *separatedString = [trimString componentsSeparatedByString:@"\n"];
        for (int i = 0 ; i < separatedString.count; i++) {
            NSString * deleteT = [separatedString[i] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            deleteT = [deleteT stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (![deleteT isEqualToString:@""]) {
                [infos addObject:deleteT];
            }
            
        }
        
        CCFPost * ccfpost = [[CCFPost alloc]init];
        if (infos.count > 2) {
            // 说明有标题
            ccfpost.postTitle = infos[2];
            ccfpost.postTime = infos[1];
            ccfpost.postLouCeng = infos[0];
        } else{
            ccfpost.postTime = infos[1];
            ccfpost.postLouCeng = infos[0];
        }
        
        ccfpost.postID = [[[postInfoNode attribute:@"id"] componentsSeparatedByString:@"td_post_"]lastObject];
        
        // post_message
        IGXMLNodeSet * postContentNodeSet = [[postNode children][1] children];


        if ([ccfpost.postLouCeng isEqualToString:@"#1"]) {
            ccfpost.postContent = [postContentNodeSet[2] innerHtml];
        } else{
            IGXMLNode * postContent = postContentNodeSet[postContentNodeSet.count - 1];
            
            ccfpost.postContent = [postContent innerHtml];
        }
        ccfpost.userInfo = ccfuser;
        
        // 添加解析出来的Post
        [posts addObject:ccfpost];
        
        
    }
    
    NSLog(@"================= end");
    return posts;
}








- (NSString *)replaceUnicode:(NSString *)unicodeStr{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(UIButton *)sender {
    LoginViewController *login = [[LoginViewController alloc]init];
    [self presentViewController:login animated:YES completion:^{
        //
    }];
}
@end
