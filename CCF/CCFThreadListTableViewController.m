//
//  CCFThreadTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadListTableViewController.h"


#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"
#import "CCFParser.h"
#import "CCFThreadListCell.h"


@interface CCFThreadListTableViewController ()

@end

@implementation CCFThreadListTableViewController

@synthesize threadList = _threadList;
@synthesize threadTopList = _threadTopList;

@synthesize entry;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.threadList == nil) {
        self.threadList = [NSMutableArray array];
    }
    
    if (self.threadTopList == nil) {
        self.threadTopList = [NSMutableArray array];
    }
    
    NSLog(@"viewDidLoad    %@   %@", entry.urlId, entry.page);
    
    
    
    CCFBrowser * browser = [[CCFBrowser alloc]init];
    
    
    NSString * userID = [browser getCurrentCCFUser];
    
    
    NSLog(@"%@", userID);
    
    
    [browser browseWithUrl:[CCFUrlBuilder buildFormURL:entry.urlId withPage:entry.page ]:^(NSString* result) {
        
        CCFParser *parser = [[CCFParser alloc]init];
        
        NSMutableArray<CCFThreadList *> * threadList = [parser parseThreadListFromHtml:result withThread:entry.urlId andContainsTop:YES];
    
        for (CCFThreadList * thread in threadList) {
            if (thread.isTopThread) {
                [self.threadTopList addObject:thread];
            }else{
                [self.threadList addObject:thread];
            }
        }
        

        [self.tableView reloadData];
        
    }];
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.threadTopList.count;
    }
    return self.threadList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *QuoteCellIdentifier = @"CCFThreadListCellIdentifier";
    
    CCFThreadListCell *cell = (CCFThreadListCell*)[tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
    
//    if(cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CCFThreadViewCell" owner:self options:nil];
//        
//        cell = [nib lastObject];
//        
//    }
    
    if (indexPath.section == 0) {
        CCFThreadList *play = self.threadTopList[indexPath.row];
        
        cell.threadTitle.text = play.threadTitle;
    } else{
        CCFThreadList *play = self.threadList[indexPath.row];
        
        cell.threadTitle.text = play.threadTitle;
    }

    
    return cell;
}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
