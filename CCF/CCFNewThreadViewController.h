//
//  CCFNewThreadViewController.h
//  CCF
//
//  Created by 迪远 王 on 16/1/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundCornerUITextView.h"
#import "TransValueDelegate.h"
#import "SelectPhotoCollectionViewCell.h"

@interface CCFNewThreadViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet RoundCornerUITextView *message;

- (IBAction)createThread:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)pickPhoto:(id)sender;


@property (weak, nonatomic) IBOutlet UICollectionView *selectPhotos;

@end
