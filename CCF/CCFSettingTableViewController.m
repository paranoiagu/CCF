//
//  CCFSettingTableViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/4/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSettingTableViewController.h"
#import "UIStoryboard+CCF.h"
#import "NSUserDefaults+Setting.h"

@interface CCFSettingTableViewController ()

@end

@implementation CCFSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UIStoryboard * storyboard = [UIStoryboard mainStoryboard];
        CCFSettingTableViewController *settingController = [storyboard instantiateViewControllerWithIdentifier:@"CCFSettingTableViewController"];
        [self.navigationController pushViewController:settingController animated:YES];
    }
    
}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchSignature:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setSignature:sender.isOn];
}

- (IBAction)switchTopThread:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setTopThreadPost:sender.isOn];
}
@end
