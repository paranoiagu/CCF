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
#import "NSUserDefaults+CCF.h"
#import "CCFFavFormControllerCell.h"

@interface CCFFavFormController (){
    CCFBrowser *_browser;
    NSMutableArray<FormEntry *> * _favForms;
}

@end

@implementation CCFFavFormController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    _browser = [[CCFBrowser alloc]init];
    
    
    
    
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    
    if (userDef.favFormIds == nil) {
        [_browser browseWithUrl:[CCFUrlBuilder buildFavFormURL] :^(NSString* result) {
            CCFParser * parser = [[CCFParser alloc]init];
            _favForms = [parser parseFavFormFormHtml:result];
            [self.tableView reloadData];
            
        }];
    } else{
        CCFCoreDataManager * manager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryForm];
        _favForms = [[manager selectFavForms:userDef.favFormIds] mutableCopy];
        [self.tableView reloadData];
    }

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _favForms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID = @"CCFFavFormControllerCell";
    CCFFavFormControllerCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    FormEntry * entry = _favForms[indexPath.row];
    
    cell.form.text = [entry formName];
    
    return cell;
}

@end
