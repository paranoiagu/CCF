//
//  CCFNewThreadViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFNewThreadViewController.h"
#import "CCFBrowser.h"



@interface CCFNewThreadViewController (){
    NSString * fId;
    CCFBrowser * broswer;
}

@end

@implementation CCFNewThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    fId = _entry.urlId;
    broswer = [[CCFBrowser alloc]init];
    
}



- (IBAction)createThread:(id)sender {
    [broswer createNewThreadForForm:fId withSubject:_subject.text andMessage:_message.text];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
