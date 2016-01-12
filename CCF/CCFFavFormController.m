//
//  CCFFavFormController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFFavFormController.h"
#import "CCFForm.h"
#import "CCFUrlBuilder.h"
#import "CCFBrowser.h"
#import "CCFParser.h"
#import "CCFCoreDataManager.h"

@interface CCFFavFormController (){
    CCFBrowser *_browser;
}

@end

@implementation CCFFavFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    _browser = [[CCFBrowser alloc]init];
    
    [_browser browseWithUrl:[CCFUrlBuilder buildFavFormURL] :^(NSString* result) {
        CCFParser * parser = [[CCFParser alloc]init];
        [parser parseFavFormFormHtml:result];
        
    }];
    
    
    CCFCoreDataManager * manager = [[CCFCoreDataManager alloc] init];
    
    NSMutableArray *forms = [manager selectData];
    
    NSLog(@"%@", forms);

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}


@end
