//
//  CCFThreadDetailTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadDetailTableViewController.h"
#import "CCFThreadDetailCell.h"
#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"
#import "CCFParser.h"

@interface CCFThreadDetailTableViewController ()

@end

@implementation CCFThreadDetailTableViewController

@synthesize entry;
@synthesize posts = _posts;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"CCFThreadDetailTableViewController viewDidLoad    %@   %@", entry.urlId, entry.page);
    
    CCFBrowser * browser = [[CCFBrowser alloc]init];
    [browser browseWithUrl:[CCFUrlBuilder buildThreadURL:entry.urlId withPage:entry.page]:^(NSString* result) {
        
        CCFParser *parser = [[CCFParser alloc]init];
        
        NSMutableArray<CCFPost *> * parsedPosts = [parser parsePostFromThreadHtml:result];
        
        if (self.posts == nil) {
            self.posts = [NSMutableArray array];
        }
        
        [self.posts addObjectsFromArray:parsedPosts];
        
        for (CCFPost * post in self.posts) {
            NSLog(@"=========>>>>>    %@", post.postContent);
        }
        [self.tableView reloadData];
        
    }];

    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"CCFThreadDetailCellIdentifier";
    
    CCFThreadDetailCell *cell = (CCFThreadDetailCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    
    CCFPost *post = self.posts[indexPath.row];
    
//    cell.postContent.text = post.postContent;
    
    NSString * htmlString = post.postContent;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    
    [cell.postCpntent setText:post.postContent];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    // 列寬
    CGFloat contentWidth = self.tableView.frame.size.width;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:14];
    // 該行要顯示的內容
    NSString *content = [[self.posts objectAtIndex:row] postContent];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:NSLineBreakByCharWrapping];// UILineBreakModeWordWrap
    
    // 這裏返回需要的高度
    return size.height+20;
}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
