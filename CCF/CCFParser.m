//
//  CCGParser.m
//  CCF
//
//  Created by 迪远 王 on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import "CCFParser.h"
#import <IGHTMLQuery.h>
#import "CCFShowThreadPage.h"
#import "CCFSearchThread.h"
#import "CCFPage.h"
#import "FormEntry+CoreDataProperties.h"
#import "CCFCoreDataManager.h"
#import "NSUserDefaults+CCF.h"
#import "NSString+Regular.h"
#import "CCFForm.h"
#import "PrivateMessage.h"
#import "CCFSimpleThread.h"
#import "CCFSearchPage.h"
#import "IGHTMLDocument+QueryNode.h"
#import "IGXMLNode+Children.h"


@implementation CCFParser

-(CCFPage *)parseThreadListFromHtml:(NSString *)html withThread:(int) threadId andContainsTop:(BOOL)containTop{
    
    CCFPage * page = [[CCFPage alloc] init];
    
    NSString * path = [NSString stringWithFormat:@"//*[@id='threadbits_forum_%d']/tr", threadId];
    
    NSMutableArray<CCFNormalThread *> * threadList = [NSMutableArray<CCFNormalThread *> array];
    
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath: path];
    
    NSInteger totaleListCount = -1;
    
    for (int i = 0; i < contents.count; i++){
        IGXMLNode * threadListNode = contents[i];
        
        if (threadListNode.children.count > 4) { // 要大于4的原因是：过滤已经被删除的帖子
            
            CCFNormalThread * ccfthreadlist = [[CCFNormalThread alloc]init];
            
            // title
            IGXMLNode * threadTitleNode = threadListNode.children [2];
            
            NSString * titleInnerHtml = [threadTitleNode innerHtml];
            
            NSRange range = [titleInnerHtml rangeOfString:@"<font color=\"red\"><b>[置顶]</b></font>"];
            if (!containTop && !(range.location == NSNotFound)) {
                continue;
            }
            ccfthreadlist.isTopThread = !(range.location == NSNotFound);

            
            NSString *titleAndCategory = [self parseTitle: titleInnerHtml];
            IGHTMLDocument * titleTemp = [[IGHTMLDocument alloc]initWithXMLString:titleAndCategory error:nil];
            
            NSString * titleText = [titleTemp text];
            
            //分离出Title 和 Category
            ccfthreadlist.threadCategory = [self spliteCategory:titleText];
            
            ccfthreadlist.threadTitle = [self spliteTitle:titleText];
            
            //[@"showthread.php?t=" length]    17的由来
            ccfthreadlist.threadID = [[titleTemp attribute:@"href"] substringFromIndex: 17];
            
            IGXMLNode * authorNode = threadListNode.children [3];

            NSString * authorIdStr = [authorNode innerHtml];
            ccfthreadlist.threadAuthorID = [authorIdStr stringWithRegular:@"\\d+"];
            
            ccfthreadlist.threadAuthorName = [authorNode text];
            
            IGXMLNode * lastPostTime = [threadListNode childrenAtPosition:4];
            ccfthreadlist.lastPostTime = [[lastPostTime text] trim];
            
            IGXMLNode * commentCountNode = threadListNode.children [5];
            ccfthreadlist.postCount = [commentCountNode text];
            
            [threadList addObject:ccfthreadlist];
        }
    }
    
    // 总页数
    if (totaleListCount == -1) {
        IGXMLNodeSet* totalPageSet = [document queryWithXPath:@"//*[@id='inlinemodform']/table[4]/tr[1]/td[2]/div/table/tr/td[1]"];
        
        if (totalPageSet == nil) {
            totaleListCount = 1;
            page.totalPageCount = 1;
        }else{
            IGXMLNode * totalPage = totalPageSet.firstObject;
            NSString * pageText = [totalPage innerHtml];
            NSString * numberText = [[pageText componentsSeparatedByString:@"，"]lastObject];
            numberText = [numberText stringWithRegular:@"\\d+"];
            NSUInteger totalNumber = [numberText integerValue];
            //NSLog(@"总页数：   %@", pageText);
            page.totalPageCount = totalNumber;
            totaleListCount = totalNumber;
        }
        
    } else{
        page.totalPageCount = totaleListCount;
    }
    page.dataList = threadList;
    
    return page;
    
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




-(CCFShowThreadPage *)parseShowThreadWithHtml:(NSString *)html{
    
    // 查找设置了字体的回帖
    NSArray * fontSetString = [html arrayWithRegulat:@"<font size=\"\\d+\">"];
    
    NSString * fixFontSizeHTML= html;
    
    for (NSString * tmp in fontSetString) {
        fixFontSizeHTML = [fixFontSizeHTML stringByReplacingOccurrencesOfString:tmp withString:@"<font size=\"\2\">"];
    }
    // 去掉_http hxxp
    NSString * fuxkHttp = fixFontSizeHTML;
    NSArray * httpArray = [fixFontSizeHTML arrayWithRegulat:@"(_http|hxxp|_https|hxxps)://[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?"];
    NSString * httpPattern = @"<a href=\"%@\" target=\"_blank\">%@</a>";
    for (NSString * http in httpArray) {
        NSString * fixedHttp = [http stringByReplacingOccurrencesOfString:@"_http://" withString:@"http://"];
        fixedHttp = [fixedHttp stringByReplacingOccurrencesOfString:@"hxxp://" withString:@"http://"];
        fixedHttp = [fixedHttp stringByReplacingOccurrencesOfString:@"hxxps://" withString:@"https://"];
        fixedHttp = [fixedHttp stringByReplacingOccurrencesOfString:@"_https://" withString:@"https://"];
        
        NSString * patterned = [NSString stringWithFormat:httpPattern, fixedHttp, fixedHttp];
        fuxkHttp = [fuxkHttp stringByReplacingOccurrencesOfString:http withString:patterned];
        
    }
    
    
    
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:fuxkHttp error:nil];
    
    CCFShowThreadPage * thread = [[CCFShowThreadPage alloc]init];
    
    thread.dataList = [self parseShowThreadPosts:document];
    

    IGXMLNode * titleNode = [document queryWithXPath:@"/html/body/div[2]/div/div/table[2]/tr/td[1]/table/tr[2]/td/strong"].firstObject;
    thread.threadTitle = titleNode.text;
    

    IGXMLNodeSet * threadInfoSet = [document queryWithXPath:@"/html/body/div[4]/div/div/table[1]/tr/td[2]/div/table/tr"];
    
    if (threadInfoSet == nil || threadInfoSet.count == 0) {
        thread.totalPageCount = 1;
        thread.currentPage = 1;
        thread.totalCount = thread.dataList.count;
        
    } else{
        IGXMLNode *currentPageAndTotalPageNode = threadInfoSet.firstObject.firstChild;
        NSString * currentPageAndTotalPageString = currentPageAndTotalPageNode.text;
        NSArray *pageAndTotalPage = [currentPageAndTotalPageString componentsSeparatedByString:@"页，共"];
        
        thread.totalPageCount = [[[pageAndTotalPage.lastObject stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"页" withString:@""] intValue];
        thread.currentPage = [[[pageAndTotalPage.firstObject stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"第" withString:@""] intValue];
        
        IGXMLNode *totalPostCount = [threadInfoSet.firstObject children][1];
        
        NSString * totalPostString = [totalPostCount.firstChild attribute:@"title"];
        NSString *tmp = [totalPostString componentsSeparatedByString:@"共计 "].lastObject;
        thread.totalCount = [[tmp stringByReplacingOccurrencesOfString:@" 条." withString:@""] intValue];
        
    }
    
    return thread;
}






-(NSMutableArray<CCFPost *> *)parseShowThreadPosts:(IGHTMLDocument *)document{
    
    NSMutableArray<CCFPost*> * posts = [NSMutableArray array];
    
    // 发帖内容的 table -> td
    IGXMLNodeSet *postMessages = [document queryWithXPath:@"//*[@id='posts']/div[*]/div/div/div/table/tr[1]/td[2]"];
    
    // 发帖时间
    NSString * xPathTime = @"//*[@id='table1']/tr/td[1]/div";
    
    
    for (IGXMLNode * node in postMessages) {
        
        CCFPost * ccfpost = [[CCFPost alloc]init];
        
        
        NSString * postId = [[[node attribute:@"id"] componentsSeparatedByString:@"td_post_"]lastObject];
        
        
        IGXMLDocument * postDocument = [[IGHTMLDocument alloc] initWithHTMLString:node.html error:nil];
        
        IGXMLNode * time = [postDocument queryWithXPath:xPathTime].firstObject;
        
        
        NSString *xPathMessage = [NSString stringWithFormat:@"//*[@id='post_message_%@']", postId];
        IGXMLNode *message = [postDocument queryWithXPath:xPathMessage].firstObject;
        
        ccfpost.postContent = message.html;
        
        
        NSString * pattern = @"<img %@ width=\"300\" height=\"300\" />";
        NSString * reg = @"<img src=\"http.*\" border=\"0\" alt=\"(.*)?(\n*)?(\\W*)?.*(\\W*)?(.*)\"><br>";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
        
        // 添加的图片
        NSString * html = message.html;
        NSArray * result = [regex matchesInString:html options:0 range:NSMakeRange(0, html.length)];
        for (NSTextCheckingResult *tmpresult in result) {
            
            NSString * image = [html substringWithRange:tmpresult.range];
            NSString * src = [image stringWithRegular:@"src=\"\\S*\""];
            NSString *fixedImage = [NSString stringWithFormat:pattern, src];
            ccfpost.postContent = [ccfpost.postContent stringByReplacingOccurrencesOfString:image withString:fixedImage];
        }

        // 上传的附件
        NSString *xPathAttImage = [NSString stringWithFormat:@"//*[@id='td_post_%@']/div[2]/fieldset/div", postId];
        IGXMLNode *attImage = [postDocument queryWithXPath:xPathAttImage].firstObject;

        
        if (attImage != nil) {

            NSString * allImage = @"";
            
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img class=\"attach\" src=\"attachment.php\\?attachmentid=(\\d+)" options:NSRegularExpressionCaseInsensitive error:nil];
            
            NSArray * result = [regex matchesInString:attImage.html options:0 range:NSMakeRange(0, attImage.html.length)];
            
            for (NSTextCheckingResult *tmpresult in result) {
                
                //    <img class="attach" src="attachment.php?attachmentid=872113
                NSString * image = [[attImage.html substringWithRange:tmpresult.range] stringByAppendingString:@"\"><br>"];
                NSString * fixedImage = [image stringByReplacingOccurrencesOfString:@"class=\"attach\"" withString:@"width=\"300\" height=\"300\""];
                NSString * fixUrl = [fixedImage stringByReplacingOccurrencesOfString:@"src=\"attachment.php" withString:@"src=\"https://bbs.et8.net/bbs/attachment.php"];
                
                allImage = [allImage stringByAppendingString:fixUrl];

            }
            ccfpost.postContent = [ccfpost.postContent stringByAppendingString:allImage];
        }
        
        NSRange louCengRange = [time.text rangeOfString:@"#\\d+" options:NSRegularExpressionSearch];
        
        if (louCengRange.location != NSNotFound) {
            ccfpost.postLouCeng = [time.text substringWithRange:louCengRange];
        }
        
        
        NSRange timeRange = [time.text rangeOfString:@"\\d{4}-\\d{2}-\\d{2}, \\d{2}:\\d{2}:\\d{2}" options:NSRegularExpressionSearch];
        
        if (timeRange.location != NSNotFound) {
            ccfpost.postTime = [time.text substringWithRange:timeRange];
        }
        // 保存数据
        ccfpost.postID = postId;
        
        // 添加数据
        [posts addObject:ccfpost];
        
        
    }
    

    // 发帖账户信息 table -> td
    //*[@id='posts']/div[1]/div/div/div/table/tr[1]/td[1]
    IGXMLNodeSet *postUserInfo = [document queryWithXPath:@"//*[@id='posts']/div[*]/div/div/div/table/tr[1]/td[1]"];
    //*[@id="post"]/tbody/tr[1]/td[1]
    
    int postPointer = 0;
    for (IGXMLNode * userInfoNode in postUserInfo) {
        
        if(userInfoNode.children.count < 5){
            continue;
        }
        IGXMLNode *nameNode = userInfoNode.firstChild.firstChild;
        
        CCFUser* ccfuser = [[CCFUser alloc]init];
        
        NSString *name = nameNode.innerHtml;
        ccfuser.userName = name;
        NSString *nameLink = [nameNode attribute:@"href"];
        ccfuser.userLink = [@"https://bbs.et8.net/bbs/" stringByAppendingString:nameLink];
        ccfuser.userID = [nameLink stringWithRegular:@"\\d+"];
        //avatar
        IGXMLNode * avatarNode = userInfoNode.children[1];
        NSString * avatarLink = [[[avatarNode children] [1] firstChild] attribute:@"src"];
        avatarLink = [[avatarLink componentsSeparatedByString:@"/"]lastObject];
        
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
        
        
        posts[postPointer].postUserInfo = ccfuser;
        
        CCFPost * newPost = posts[postPointer];
        newPost.postUserInfo = ccfuser;
        [posts removeObjectAtIndex:postPointer];
        [posts insertObject:newPost atIndex:postPointer];

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

-(NSString *)parsePostHash:(NSString *)html{
    //<input type="hidden" name="posthash" value="81b4404ec1db053e78df16a3536ee7ab" />
    NSString * hash = [html stringWithRegular:@"<input type=\"hidden\" name=\"posthash\" value=\"\\w{32}\" />" andChild:@"\\w{32}"];
    
    return hash;
}

-(NSString *)parseLoginErrorMessage:(NSString *)html{
    // /html/body/div[2]/div/div/table[3]/tr[2]/td/div/div/div
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath: @"/html/body/div[2]/div/div/table[3]/tr[2]/td/div/div/div"];
    
    return contents.firstObject.text;
    
}

-(CCFPage *)parseFavThreadListFormHtml:(NSString *)html{
    CCFPage * page = [[CCFPage alloc] init];
    
    NSString * path = @"/html/body/div[2]/div/div/table[3]/tr/td[3]/form[2]/table/tr[position()>2]";
    
    //*[@id="threadbits_forum_147"]/tr[1]
    
    NSMutableArray<CCFSimpleThread *> * threadList = [NSMutableArray<CCFSimpleThread *> array];
    
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath: path];
    
    NSInteger totaleListCount = -1;
    
    for (int i = 0; i < contents.count; i++){
        IGXMLNode * threadListNode = contents[i];
        
        if (threadListNode.children.count > 4) { // 要大于4的原因是：过滤已经被删除的帖子
            
            CCFSimpleThread * ccfthreadlist = [[CCFSimpleThread alloc]init];
            
            // title
            IGXMLNode * threadTitleNode = threadListNode.children [2];
            
            NSString * titleInnerHtml = [threadTitleNode innerHtml];

            NSString *titleAndCategory = [self parseTitle: titleInnerHtml];
            //分离出Title 和 Category
            ccfthreadlist.threadTitle = [self spliteTitle:titleAndCategory];
            ccfthreadlist.threadCategory = [self spliteCategory:titleAndCategory];

            IGHTMLDocument * titleTemp = [[IGHTMLDocument alloc]initWithXMLString:titleAndCategory error:nil];
            
            //[@"showthread.php?t=" length]    17的由来
            ccfthreadlist.threadID = [[titleTemp attribute:@"href"] substringFromIndex: 17];
            ccfthreadlist.threadTitle = [titleTemp text];
            
            
            IGXMLNode * authorNode = threadListNode.children [3];
            
            NSString * authorIdStr = [authorNode innerHtml];
            ccfthreadlist.threadAuthorID = [authorIdStr stringWithRegular:@"\\d+"];
            
            ccfthreadlist.threadAuthorName = [authorNode text];
        
            [threadList addObject:ccfthreadlist];
        }
    }
    
    // 总页数
    if (totaleListCount == -1) {
        IGXMLNodeSet* totalPageSet = [document queryWithXPath:@"//*[@id='inlinemodform']/table[4]/tr[1]/td[2]/div/table/tr/td[1]"];
        
        if (totalPageSet == nil) {
            totaleListCount = 1;
            page.totalPageCount = 1;
        }else{
            IGXMLNode * totalPage = totalPageSet.firstObject;
            NSString * pageText = [totalPage innerHtml];
            NSString * numberText = [[pageText componentsSeparatedByString:@"，"]lastObject];
            NSUInteger totalNumber = [numberText integerValue];
            NSLog(@"总页数：   %@", pageText);
            page.totalPageCount = totalNumber;
            totaleListCount = totalNumber;
        }
        
    } else{
        page.totalPageCount = totaleListCount;
    }
    page.dataList = threadList;
    
    return page;
}


-(CCFSearchPage*)parseSearchPageFromHtml:(NSString *)html{
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet * searchNodeSet = [document queryWithXPath:@"//*[@id='threadslist']/tr[*]"];
    
    if (searchNodeSet == nil || searchNodeSet.count == 0) {
        return nil;
    }
    
    
    CCFSearchPage * resultPage = [[CCFSearchPage alloc]init];

    IGXMLNode * postTotalCountNode = [document queryWithXPath:@"//*[@id='threadslist']/tr[1]/td/span[1]"].firstObject;

    NSString * postTotalCount = [postTotalCountNode.text stringWithRegular:@"共计 \\d+ 条" andChild:@"\\d+"];
    // 1. 结果总条数
    resultPage.totalPageCount = [postTotalCount integerValue];
    
    IGXMLNode * pageNode = [document queryWithXPath:@"/html/body/div[2]/div/div/table[3]/tr/td/div/table/tr/td[1]"].firstObject;
    // 2. 当前页数 和 总页数
    if (pageNode == nil) {
        resultPage.currentPage = 1;
        resultPage.totalPageCount = 1;
    } else{
        resultPage.currentPage = [[pageNode.text stringWithRegular:@"第 \\d+ 页" andChild:@"\\d+"] integerValue];
        resultPage.totalPageCount = [[pageNode.text stringWithRegular:@"共 \\d+ 页" andChild:@"\\d+"] integerValue];
    }
    
    NSMutableArray<CCFSearchThread*>* post = [NSMutableArray array];
    
    for (IGXMLNode *node in searchNodeSet) {
        
        if (node.children.count == 9) {
            // 9个节点是正确的输出结果
            CCFSearchThread * result = [[CCFSearchThread alloc]init];
            
            NSString * postIdNode = [node.children[2] html];
            NSString * postId = [postIdNode stringWithRegular:@"id=\"thread_title_\\d+\"" andChild:@"\\d+"];
            
            
            NSString * postTitle = [[[node.children[2] text] trim] componentsSeparatedByString:@"\n"].firstObject;
            NSString * postAuthor = [node.children[3] text];
            NSString * postAuthorId = [[node.children[3] html] stringWithRegular:@"=\\d+" andChild:@"\\d+"];
            NSString * postTime = [node.children[4] text];
            NSString * postBelongForm = [node.children[8] text];
            
            result.threadCategory = [self spliteCategory:postTitle];
            
            result.threadID = postId;
            result.threadTitle = [postTitle trim];
            result.threadAuthorName = postAuthor;
            result.threadAuthorID = postAuthorId;
            result.lastPostTime = [postTime trim];
            result.fromFormName = postBelongForm;
            
            
            [post addObject:result];
        }
    }
    
    resultPage.redirectUrl = [self parseListMyThreadRedirectUrl: html];
    resultPage.dataList = post;
    
    return resultPage;
}

-(NSString *) spliteCategory:(NSString*)fullTitle{
    NSString * type = [fullTitle stringWithRegular:@"【.{1,4}】"];
    NSString * category = [type substringWithRange:NSMakeRange(1, type.length - 2)];
    return type == nil ? @"讨论" : category;
}

-(NSString *) spliteTitle:(NSString*)fullTitle{
    NSString * type = [fullTitle stringWithRegular:@"【.{1,4}】"];
    return type == nil ? fullTitle : [fullTitle substringFromIndex:type.length];
}

-(NSMutableArray<CCFForm *> *)parseFavFormFormHtml:(NSString *)html{
    
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet * favFormNodeSet = [document queryWithXPath:@"//*[@id='collapseobj_usercp_forums']/tr[*]/td[2]/div[1]/a"];
    

    NSMutableArray* ids = [NSMutableArray array];
    
    //<a href="forumdisplay.php?f=158">『手机◇移动数码』</a>
    for (IGXMLNode *node in favFormNodeSet) {
        NSString * idsStr = [node.html stringWithRegular:@"f=\\d+" andChild:@"\\d+"];
        [ids addObject:[NSNumber numberWithInt:[idsStr intValue]]];
    }
    
    [[NSUserDefaults standardUserDefaults] saveFavFormIds:ids];


    // 通过ids 过滤出Form
    CCFCoreDataManager * manager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryForm];
    NSArray * result = [manager selectData:^NSPredicate *{
         return [NSPredicate predicateWithFormat:@"formId IN %@", ids];
    }];
    
    NSMutableArray<CCFForm *> * forms = [NSMutableArray arrayWithCapacity:result.count];
    
    for (FormEntry * entry in result) {
        CCFForm * form = [[CCFForm alloc] init];
        form.formName = entry.formName;
        form.formId = [entry.formId intValue];
        [forms addObject:form];
    }

    return forms;
}


-(CCFPage *)parsePrivateMessageFormHtml:(NSString *)html{
    CCFPage * page = [[CCFPage alloc] init];
    
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];

    IGXMLNodeSet * totalPage = [document queryWithXPath:@"//*[@id='pmform']/table[1]/tr/td/div/table/tr/td[1]"];
    //<td class="vbmenu_control" style="font-weight:normal">第 1 页，共 5 页</td>
    NSString * fullText = [[totalPage firstObject] text];
    NSString * currentPage = [fullText stringWithRegular:@"第 \\d+ 页" andChild:@"\\d+"];
    page.currentPage = [currentPage integerValue];
    NSString * totalPageCount = [fullText stringWithRegular:@"共 \\d+ 页" andChild:@"\\d+"];
    page.totalPageCount = [totalPageCount integerValue];
    
    
    
    
    IGXMLNodeSet * totalCount = [document queryWithXPath:@"//*[@id='pmform']/table[1]/tr/td/div/table/tr/td[7]"];
    NSString * totalCountStr = [[[totalCount firstObject] html] stringWithRegular:@"共计 \\d+" andChild:@"\\d+"];
    page.totalCount = [totalCountStr integerValue];
    
    
    
    NSMutableArray<PrivateMessage*> * messagesList  = [NSMutableArray array];
    
    IGXMLNodeSet *messages = [document queryWithXPath:@"//*[@id='pmform']/table[2]/tbody[*]/tr"];
    for (IGXMLNode * node in messages) {
        long childCount = [[node children] count];
        if (childCount == 4) {
            // 有4个节点说明是正常的站内短信
            PrivateMessage * message = [[PrivateMessage alloc] init];
            
            IGXMLNodeSet * children = [node children];
            // 1. 是不是未读短信
            IGXMLNode * unreadFlag = children[0];
            message.isReaded = ![[unreadFlag html] containsString:@"pm_new.gif"];
            
            // 2. 标题
            IGXMLNode * title = [children[2] children][0];
            NSString * titleStr = [[title children] [1] text];
            message.pmTitle = titleStr;
            
            NSString * messageLink = [[[title children] [1] attribute:@"href"] stringWithRegular:@"\\d+"];
            message.pmID = messageLink;
            
            
            NSString * timeDay = [[title children] [0] text];
            
            // 3. 发送PM作者
            IGXMLNode * author = [children[2] children][1];
            NSString * authorText = [[author children] [1] text];
            message.pmAuthor = authorText;
            
            // 4. 发送者ID
            NSString *authorId;
            if (message.isReaded) {
                authorId = [[author children][1] attribute:@"onclick"];
                authorId = [authorId stringWithRegular:@"\\d+"];
            } else{
                IGXMLNode *strongNode = [author children][1];
                strongNode = [strongNode children][0];
                authorId = [strongNode attribute:@"onclick"];
                authorId = [authorId stringWithRegular:@"\\d+"];
            }
            message.pmAuthorId = authorId;

            // 5. 时间
            NSString * timeHour = [[author children] [0] text];
            message.pmTime = [[timeDay stringByAppendingString:@" "] stringByAppendingString:timeHour];
            
            [messagesList addObject:message];
            
        }
    }
    
    page.dataList = messagesList;
    
    return page;
    
}


-(CCFShowPM *)parsePrivateMessageContent:(NSString *)html{
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    
    // message content
    CCFShowPM * privateMessage = [[CCFShowPM alloc] init];
    IGXMLNodeSet * contentNodeSet = [document queryWithXPath:@"//*[@id='post_message_']"];
    privateMessage.pmContent = [[contentNodeSet firstObject] html];
    // 回帖时间
    IGXMLNodeSet * privateSendTimeSet = [document queryWithXPath:@"//*[@id='table1']/tr/td[1]/div/text()"];
    privateMessage.pmTime = [[privateSendTimeSet [2] text] trim];
    // PM ID
    IGXMLNodeSet * privateMessageIdSet = [document queryWithXPath:@"/html/body/div[2]/div/div/table[2]/tr/td[1]/table/tr[2]/td/a"];
    NSString * pmId = [[[privateMessageIdSet firstObject] attribute:@"href"] stringWithRegular:@"\\d+"];
    privateMessage.pmID = pmId;
    
    // PM Title
    IGXMLNodeSet * pmTitleSet = [document queryWithXPath:@"/html/body/div[2]/div/div/table[2]/tr/td[1]/table/tr[2]/td/strong"];
    NSString * pmTitle = [[[pmTitleSet firstObject] text] trim];
    privateMessage.pmTitle = pmTitle;
    
    
    // User Info
    CCFUser * pmAuthor = [[CCFUser alloc] init];
    IGXMLNode *userInfoNode = [document queryNodeWithXPath:@"//*[@id='post']/tr[1]/td[1]"];
    // 用户名
    NSString * name = [[[userInfoNode childrenAtPosition:0] childrenAtPosition:0] text];
    pmAuthor.userName = name;
    // 用户ID
    NSString * userId = [[[[userInfoNode childrenAtPosition:0] childrenAtPosition:0] attribute:@"href"] stringWithRegular:@"\\d+"];
    pmAuthor.userID = userId;
    
    // 用户头像
    NSString* userAvatar = [[[[[[userInfoNode childrenAtPosition:1] childrenAtPosition:1] childrenAtPosition:0] attribute:@"src"] componentsSeparatedByString:@"/"] lastObject];
    pmAuthor.userAvatar = userAvatar;
    
    // 用户等级
    NSString * userRank = [[ userInfoNode childrenAtPosition:3] text];
    pmAuthor.userRank = userRank;
    // 注册日期
    NSString * userSignDate = [[[[[[userInfoNode childrenAtPosition:4] childrenAtPosition:1] childrenAtPosition:1] text] componentsSeparatedByString:@": "] lastObject];
    pmAuthor.userSignDate = userSignDate;
    // 帖子数量
    NSString * postCount = [[[[[[[userInfoNode childrenAtPosition:4] childrenAtPosition:1] childrenAtPosition:2] text] trim] componentsSeparatedByString:@": "] lastObject];
    pmAuthor.userPostCount = postCount;
    
    // 精华 和 解答

    //===========
    
    privateMessage.pmUserInfo = pmAuthor;
    return privateMessage;
}

-(NSString *)parseQuickReplyQuoteContent:(NSString *)html{
    
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet * nodeSet = [document queryWithXPath:@"//*[@id='vB_Editor_QR_textarea']"];
    NSString * node = [[nodeSet firstObject] text];
    return node;
}


-(NSString *)parseQuickReplyTitle:(NSString *)html{
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet * nodeSet = [document queryWithXPath:@"//*[@id='message_form']/div[1]/div/div/div[3]/input[9]"];
    
    NSString * node = [[nodeSet firstObject] attribute:@"value"];
    return node;
    
}

-(NSString *)parseQuickReplyTo:(NSString *)html{
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet * nodeSet = [document queryWithXPath:@"//*[@id='message_form']/div[1]/div/div/div[3]/input[10]"];
    NSString * node = [[nodeSet firstObject] attribute:@"value"];
    return node;
}
-(NSString *)parseUserAvatar:(NSString *)html userId:(NSString *)userId{
    NSString * regular = [NSString stringWithFormat:@"/avatar%@_(\\d+).gif", userId];
    NSString * avatar = [html stringWithRegular:regular];
    return avatar;
}



-(NSString *)parseListMyThreadRedirectUrl:(NSString *)html{
    NSString * xPath = @"/html/body/div[2]/div/div/table[2]/tr/td[1]/table/tr[2]/td/a";
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet * nodeSet = [document queryWithXPath:xPath];
    
    return [nodeSet.firstObject attribute:@"href"];
    
}

-(CCFUserProfile *)parserProfile:(NSString *)html userId:(NSString *)userId{
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    CCFUserProfile * profile = [[CCFUserProfile alloc] init];
    // 用户名
    NSString * userNameXPath = @"//*[@id='username_box']/h1/text()";
    profile.profileName = [[self queryText:document withXPath:userNameXPath] trim];
    
    // 用户等级
    NSString * rankXPath = @"//*[@id='username_box']/h2";
    profile.profileRank = [self queryText:document withXPath:rankXPath];
    
    // 注册日期
    NSString * registerXPath = @"//*[@id='collapseobj_stats_mini']/div[1]/table/tr/td[1]/dl/dd[1]";
    profile.profileRegisterDate = [self queryText:document withXPath:registerXPath];
    
    // 最近活动时间
    NSString * lastLoginDayXPath = @"//*[@id='collapseobj_stats']/div/fieldset[2]/ul/li[1]/text()";
    NSString * lastDay = [[self queryText:document withXPath:lastLoginDayXPath] trim];
    
    NSString * lastLoginTimeXPath = @"//*[@id='collapseobj_stats']/div/fieldset[2]/ul/li[1]/span[2]";
    NSString * lastTime = [[self queryText:document withXPath:lastLoginTimeXPath] trim];
    if (lastTime == nil) {
        lastTime = @"隐私";
        profile.profileRecentLoginDate = lastTime;
    } else{
        profile.profileRecentLoginDate = [NSString stringWithFormat:@"%@ %@", lastDay, lastTime];
    }
    
    
    // 帖子总数
    NSString * postCountXPath = @"//*[@id='collapseobj_stats_mini']/div[1]/table/tr/td[1]/dl/dd[2]";
    NSString * postCount = [self queryText:document withXPath:postCountXPath];
    profile.profileTotalPostCount = postCount;
    
    profile.profileUserId = userId;
    return profile;
}


-(NSString *)queryText:(IGHTMLDocument*)document withXPath:(NSString*)xpath{
    IGXMLNodeSet * nodeSet = [document queryWithXPath:xpath];
    NSString * text = [nodeSet.firstObject text];
    return text;
}


























@end
