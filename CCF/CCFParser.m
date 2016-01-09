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




-(NSMutableArray<CCFThreadList *> *)parseThreadListFromHtml:(NSString *)html withThread:(NSString *) threadId andContainsTop:(BOOL)containTop{
    NSString * path = [NSString stringWithFormat:@"//*[@id='threadbits_forum_%@']/tr", threadId];
    
    //*[@id="threadbits_forum_147"]/tr[1]
    
    NSMutableArray<CCFThreadList *> * threadList = [NSMutableArray<CCFThreadList *> array];
    
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath: path];
    
    NSInteger totaleListCount = -1;
    
    for (int i = 0; i < contents.count; i++){
        IGXMLNode * threadListNode = contents[i];
        if (threadListNode.children.count > 1) {
            
            CCFThreadList * ccfthreadlist = [[CCFThreadList alloc]init];
            

            
            
            
            // title
            IGXMLNode * threadTitleNode = threadListNode.children [2];
            
            NSString * titleInnerHtml = [threadTitleNode innerHtml];
            
            NSRange range = [titleInnerHtml rangeOfString:@"<font color=\"red\"><b>[置顶]</b></font>"];
            if (!containTop && !(range.location == NSNotFound)) {
                continue;
            }
            ccfthreadlist.isTopThread = !(range.location == NSNotFound);
            
            
            
            
            
            NSString *title = [self parseTitle: titleInnerHtml];
            
            IGHTMLDocument * titleTemp = [[IGHTMLDocument alloc]initWithXMLString:title error:nil];
            
            //[@"showthread.php?t=" length]    17的由来
            ccfthreadlist.threadID = [[titleTemp attribute:@"href"] substringFromIndex: 17];
            ccfthreadlist.threadTitle = [titleTemp text];
            
            
            IGXMLNode * authorNode = threadListNode.children [3];
            ccfthreadlist.threadAuthor = [authorNode text];
            
            
            IGXMLNode * commentCountNode = threadListNode.children [5];
            ccfthreadlist.threadTotalPostCount = [[commentCountNode text] intValue];
            NSLog(@"---------------> %@ ", ccfthreadlist.threadTitle);
            
            
            // 总页数
            if (totaleListCount == -1) {
                IGXMLNodeSet* totalPageSet = [document queryWithXPath:@"//*[@id='inlinemodform']/table[4]/tr[1]/td[2]/div/table/tr/td[1]"];
                
                if (totalPageSet == nil) {
                    totaleListCount = 1;
                    ccfthreadlist.threadTotalListPage = 1;
                }else{
                    IGXMLNode * totalPage = totalPageSet.firstObject;
                    NSString * pageText = [totalPage innerHtml];
                    NSString * numberText = [[pageText componentsSeparatedByString:@"，"]lastObject];
                    NSUInteger totalNumber = [numberText integerValue];
                    NSLog(@"总页数：   %@", pageText);
                    ccfthreadlist.threadTotalListPage = totalNumber;
                    totaleListCount = totalNumber;
                }
                
                
            } else{
                ccfthreadlist.threadTotalListPage = totaleListCount;
            }
            
            
            [threadList addObject:ccfthreadlist];
        }
        
        
    }
    
    //NSLog(@"%@", contents);
//
    
    return threadList;
    
}

-(NSString *) parseTitle:(NSString *) html {
    NSString *searchText = html;
    
    NSString * pattern = @"<a href=\"showthread.php\\?t.*";
    
    NSRange range = [searchText rangeOfString:pattern options:NSRegularExpressionSearch];
    
    if (range.location != NSNotFound) {
        //NSLog(@"%@", [searchText substringWithRange:range]);
        return [searchText substringWithRange:range];
    }
    return nil;
}


-(NSMutableArray<CCFPost *> *)parsePostFromThreadHtml:(NSString *)html{
    NSMutableArray * posts = [NSMutableArray array];

    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath:@"//div[@id='posts']/div[*]/div/div/div/table/tr[1]"];
    
    NSInteger totalPostPage = -1;
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
        
        

        // 找出图片tag
        if (postInfoNode.children.count >= 4) {
            IGXMLNode *node = postInfoNode.children[3];
            IGXMLNode * node2 = node.children[0];
            IGXMLNode * node3 = node2.children[1];
            NSUInteger imageCount = node3.children.count;
            
            NSString * format = @"<br><img src=\"%@\" width=\"304\" height=\"304\" >";
            
            NSString * imageTag = @"";
            for (int i = 0; i < imageCount; i++) {
                IGXMLNode * image = node3.children[i];
                NSString * formated = [NSString stringWithFormat:format, [@"https://bbs.et8.net/bbs/" stringByAppendingString:[image attribute:@"href"]] ];
                imageTag = [imageTag stringByAppendingString:formated];
                
                NSLog(@"\n\n\n++++++++++++++++++++++++++++++++++++++++++   %@   --->>>   ",  [@"https://bbs.et8.net/bbs/" stringByAppendingString:[image attribute:@"href"]]);
            }
            
            ccfpost.postContent = [ccfpost.postContent stringByAppendingString:imageTag];
            
        }
        
        
        ccfpost.userInfo = ccfuser;
        //*[@id="inlinemodform"]/table[4]/tbody/tr/td[2]/div/table/tbody/tr/td[1]

        
        // /html/body/div[2]/div/div/table[3]/tbody/tr/td[2]/div/table/tbody/tr/td[1]
        if (totalPostPage == -1) {
            IGXMLNodeSet* totalPageSet = [document queryWithXPath:@"/html/body/div[2]/div/div/table[3]/tr/td[2]/div/table/tr/td[1]"];
            
//            IGXMLNode * totalPage = totalPageSet.firstObject;
//            NSString * pageText = [totalPage innerHtml];
//            NSLog(@"帖子内容总页数总页数：   %@", pageText);
            
            if (totalPageSet == nil) {
                totalPostPage = 1;
                ccfpost.postTotalPage = 1;
            }else{
                IGXMLNode * totalPage = totalPageSet.firstObject;
                NSString * pageText = [totalPage innerHtml];
                NSString * numberText = [[pageText componentsSeparatedByString:@"，"]lastObject];
                NSUInteger totalNumber = [numberText integerValue];
                NSLog(@"总页数：   %@", pageText);
                ccfpost.postTotalPage = totalNumber;
                totalPostPage = totalNumber;
            }
            
            
        } else{
            ccfpost.postTotalPage = totalPostPage;
        }
        
        // 添加解析出来的Post
        [posts addObject:ccfpost];

    }
    return posts;
}


-(NSString *)parseSecurityToken:(NSString *)html{
    NSString *searchText = html;
    
    NSRange range = [searchText rangeOfString:@"\\d{10}-\\S{40}" options:NSRegularExpressionSearch];
    
    if (range.location != NSNotFound) {
        NSLog(@"parseSecurityToken   %@", [searchText substringWithRange:range]);
        return [searchText substringWithRange:range];
    }
    
    
    return nil;
}


-(NSString *)parseLoginErrorMessage:(NSString *)html{
    // /html/body/div[2]/div/div/table[3]/tr[2]/td/div/div/div
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath: @"/html/body/div[2]/div/div/table[3]/tr[2]/td/div/div/div"];
    
    return contents.firstObject.text;
    
}
@end
