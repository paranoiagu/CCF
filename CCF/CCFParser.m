//
//  CCGParser.m
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "CCFParser.h"
#import <IGHTMLQuery.h>

@implementation CCFParser

-(NSMutableArray<CCFPost *> *)parsePostFromThreadHtml:(NSString *)html{
    NSMutableArray * posts = [NSMutableArray array];

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
    return posts;
}

@end
