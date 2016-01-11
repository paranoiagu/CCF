//
//  CCFSearchResultCell.h
//  CCF
//
//  Created by WDY on 16/1/11.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCFSearchResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *searchResultContent;
@property (weak, nonatomic) IBOutlet UILabel *auther;
@property (weak, nonatomic) IBOutlet UILabel *postTime;
@property (weak, nonatomic) IBOutlet UILabel *form;

@end
