//
//  CCFFavFormController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/10.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFFavFormController.h"
#import "CCFUrlBuilder.h"
#import "CCFParser.h"
#import "CCFCoreDataManager.h"
#import "NSUserDefaults+CCF.h"

#import "CCFForm.h"
#import "CCFThreadListTableViewController.h"
#import "CCFNavigationController.h"
#import "CCFApi.h"

@interface CCFFavFormController (){

    CCFApi * ccfapi;
    NSMutableArray<CCFForm *> * _favForms;
}

@end

@implementation CCFFavFormController





- (void)viewDidLoad {
    [super viewDidLoad];
    _favForms = [NSMutableArray array];
    ccfapi = [[CCFApi alloc]init];
    
    
    
    
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    
    if (userDef.favFormIds == nil) {
        [ccfapi listFavoriteForms:^(BOOL isSuccess, NSMutableArray<CCFForm *> * message) {
            _favForms = message;
            [self.tableView reloadData];
        }];
    } else{
        CCFCoreDataManager * manager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryForm];
        NSArray* forms = [[manager selectFavForms:userDef.favFormIds] mutableCopy];
        
        [_favForms addObjectsFromArray:forms];
        
        [self.tableView reloadData];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CCFThreadListTableViewController * controller = segue.destinationViewController;
    
    if ([controller respondsToSelector:@selector(setEntry:)]) {
        
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSLog(@"prepareForSegue %ld      %ld   ", path.section, path.row);
        
        CCFForm * select = _favForms[path.row];
        
        CCFEntry * entry = [[CCFEntry alloc]init];
        
        entry.urlId = [NSString stringWithFormat:@"%d", select.formId];
        
        entry.page = @"1";
        
        [controller setValue:entry forKey:@"entry"];
        
        NSLog(@"prepareForSegue ");
        
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    CCFForm * form = _favForms[indexPath.row];
    
    cell.textLabel.text = form.formName;
    
    return cell;
}

- (IBAction)showLeftDrawer:(id)sender {
    CCFNavigationController * rootController = (CCFNavigationController*)self.navigationController;
    [rootController showLeftDrawer];
}
@end
