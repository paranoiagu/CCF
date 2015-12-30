//
//  LoginViewController.h
//  CCF
//
//  Created by WDY on 15/12/30.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIImageView *doorImageView;

- (IBAction)login:(id)sender;
- (IBAction)refreshDoor:(id)sender;

- (IBAction)tttttt:(id)sender;

@end
