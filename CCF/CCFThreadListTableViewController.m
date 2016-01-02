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


@interface CCFThreadListTableViewController ()

@end

@implementation CCFThreadListTableViewController

@synthesize entry;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    NSLog(@"viewDidLoad    %@   %@", entry.urlId, entry.page);
    
    
    
    CCFBrowser * browser = [[CCFBrowser alloc]init];
    
    
    NSString * userID = [browser getCurrentCCFUser];
    
    
    NSLog(@"%@", userID);
    
    
    [browser browseWithUrl:[CCFUrlBuilder buildFormURL:entry.urlId withPage:entry.page ]:^(NSString* result) {
        
        CCFParser *parser = [[CCFParser alloc]init];
        
        NSMutableArray * posts = [parser parseThreadListFromHtml:result withThread:entry.urlId andContainsTop:YES];
    
        
//        NSLog(@"%@", result);
        
    }];
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}




- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
