//
//  CCFSeniorNewPostViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/16.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCFSeniorNewPostViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *replyContent;

- (IBAction)insertSmile:(id)sender;

- (IBAction)insertPhoto:(id)sender;

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *insertCollectionView;

@end
