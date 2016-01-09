//
//  CCGParser.m
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "CCFParser.h"
#import <IGHTMLQuery.h>
#import "CCFShowThread.h"







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




-(CCFShowThread *)parseShowThreadWithHtml:(NSString *)html{
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    
    CCFShowThread * thread = [[CCFShowThread alloc]init];
    
    thread.threadPosts = [self parseShowThreadPosts:document];
    

    IGXMLNode * titleNode = [document queryWithXPath:@"/html/body/div[2]/div/div/table[2]/tr/td[1]/table/tr[2]/td/strong"].firstObject;
    thread.threadTitle = titleNode.text;
    
    

    
    
    IGXMLNodeSet * threadInfoSet = [document queryWithXPath:@"/html/body/div[4]/div/div/table[1]/tr/td[2]/div/table/tr"];
    
//    <tr>
//    <td class="vbmenu_control" style="font-weight:normal">第 1 页，共 9 页</td>
//    
//    
//    <td class="alt2"><span class="smallfont" title="显示结果从 1 到 15, 共计 127 条."><strong>1</strong></span></td>
//    <td class="alt1"><a class="smallfont" href="showthread.php?t=1317973&amp;page=2" title="显示结果从 16 到 30, 共计 127 条.">2</a></td>
//    <td class="alt1"><a class="smallfont" href="showthread.php?t=1317973&amp;page=3" title="显示结果从 31 到 45, 共计 127 条.">3</a></td>
//    <td class="alt1"><a class="smallfont" href="showthread.php?t=1317973&amp;page=4" title="显示结果从 46 到 60, 共计 127 条.">4</a></td>
//    <td class="alt1"><a class="smallfont" href="showthread.php?t=1317973&amp;page=5" title="显示结果从 61 到 75, 共计 127 条.">5</a></td>
//    <td class="alt1"><a rel="next" class="smallfont" href="showthread.php?t=1317973&amp;page=2" title="下一页 - 结果从 16 到 30, 共计 127">&gt;</a></td>
//    <td class="alt1" nowrap><a class="smallfont" href="showthread.php?t=1317973&amp;page=9" title="尾页 - 结果从 121 到 127, 共计 127">最后一页 <strong>»</strong></a></td>
//    
//    </tr>
    
    
    
    if (threadInfoSet == nil || threadInfoSet.count == 0) {
        thread.threadTotalPage = 1;
        thread.threadCurrentPage = 1;
        thread.threadTotalPostCount = thread.threadPosts.count;
        
    } else{
        IGXMLNode *currentPageAndTotalPageNode = threadInfoSet.firstObject.firstChild;
        NSString * currentPageAndTotalPageString = currentPageAndTotalPageNode.text;
        NSArray *pageAndTotalPage = [currentPageAndTotalPageString componentsSeparatedByString:@"页，共"];
        
        thread.threadTotalPage = [[[pageAndTotalPage.lastObject stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"页" withString:@""] intValue];
        thread.threadCurrentPage = [[[pageAndTotalPage.firstObject stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"第" withString:@""] intValue];
        
        IGXMLNode *totalPostCount = [threadInfoSet.firstObject children][1];
        
        NSString * totalPostString = [totalPostCount.firstChild attribute:@"title"];
        NSString *tmp = [totalPostString componentsSeparatedByString:@"共计 "].lastObject;
        thread.threadTotalPostCount = [[tmp stringByReplacingOccurrencesOfString:@" 条." withString:@""] intValue];
        
    }
    
    
    
    return thread;
}






-(NSMutableArray<CCFPost *> *)parseShowThreadPosts:(IGHTMLDocument *)document{
    
    NSMutableArray<CCFPost*> * posts = [NSMutableArray array];
    
    // 发帖内容的 table -> td
    IGXMLNodeSet *postMessages = [document queryWithXPath:@"//*[@id='posts']/div[*]/div/div/div/table/tr[1]/td[2]"];
    
    // 发帖时间
    NSString * xPathTime = @"//*[@id='table1']/tr/td[1]/div";
    
    
    int i = 0;
    
    for (IGXMLNode * node in postMessages) {
        
        CCFPost * ccfpost = [[CCFPost alloc]init];
        
        
        NSString * postId = [[[node attribute:@"id"] componentsSeparatedByString:@"td_post_"]lastObject];
        
        
        IGXMLDocument * postDocument = [[IGHTMLDocument alloc] initWithHTMLString:node.html error:nil];
        
        IGXMLNode * time = [postDocument queryWithXPath:xPathTime].firstObject;
        
        
        NSString *xPathMessage = [NSString stringWithFormat:@"//*[@id='post_message_%@']", postId];
        IGXMLNode *message = [postDocument queryWithXPath:xPathMessage].firstObject;
        
        ccfpost.postContent = message.html;
        
        
        NSString *xPathAttImage = [NSString stringWithFormat:@"//*[@id='td_post_%@']/div[2]/fieldset/div", postId];
        IGXMLNode *attImage = [postDocument queryWithXPath:xPathAttImage].firstObject;
        
        if (attImage != nil) {
            NSUInteger imageCount = attImage.children.count;
            
            NSString * format = @"<br><img src=\"%@\" width=\"304\" height=\"304\" >";
            
            NSString * imageTag = @"";
            for (int i = 0; i < imageCount; i++) {
                IGXMLNode * image = attImage.children[i];
                NSString * formated = [NSString stringWithFormat:format, [@"https://bbs.et8.net/bbs/" stringByAppendingString:[image attribute:@"href"]] ];
                imageTag = [imageTag stringByAppendingString:formated];
            }
            
            ccfpost.postContent = [ccfpost.postContent stringByAppendingString:imageTag];
        }
        
        
        
        
        NSRange louCengRange = [time.text rangeOfString:@"#\\d+" options:NSRegularExpressionSearch];
        
        if (louCengRange.location != NSNotFound) {
            ccfpost.postLouCeng = [time.text substringWithRange:louCengRange];
        }
        
        
        NSRange timeRange = [time.text rangeOfString:@"\\d{4}-\\d{2}-\\d{2}, \\d{2}:\\d{2}:\\d{2}" options:NSRegularExpressionSearch];
        
        if (timeRange.location != NSNotFound) {
            ccfpost.postTime = [time.text substringWithRange:timeRange];
        }
        
        
        
        //NSLog(@"\n%d >>>>>>>>>>>>>>\n %@ \n<<<<<<<<<<<<< \n\n", i ++ ,ccfpost.postLouCeng);
        
        
        // 保存数据
        ccfpost.postID = postId;
        
        // 添加数据
        [posts addObject:ccfpost];
        
        
    }
    
    /////////
    // 发帖账户信息 table -> td
    //*[@id='posts']/div[1]/div/div/div/table/tr[1]/td[1]
    IGXMLNodeSet *postUserInfo = [document queryWithXPath:@"//*[@id='posts']/div[*]/div/div/div/table/tr[1]/td[1]"];
    
    int postPointer = 0;
    for (IGXMLNode * userInfoNode in postUserInfo) {
        
        
        IGXMLNode *nameNode = userInfoNode.firstChild.firstChild;
        
        CCFUser* ccfuser = [[CCFUser alloc]init];
        
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
        
        
        posts[postPointer].userInfo = ccfuser;
        
        CCFPost * newPost = posts[postPointer];
        newPost.userInfo = ccfuser;
        [posts removeObjectAtIndex:postPointer];
        [posts insertObject:newPost atIndex:postPointer];
        
        // NSLog(@"\n%d >>>>>>>>>>>>>>\n %@ \n<<<<<<<<<<<<< \n\n", i ++ ,posts[postPointer].userInfo.userName);
        postPointer ++;
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
