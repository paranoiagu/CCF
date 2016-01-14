//
//  CCFNewThreadViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFNewThreadViewController.h"
#import "CCFBrowser.h"
#import "SelectPhotoCollectionViewCell.h"


@interface CCFNewThreadViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    
    
    NSString * fId;
    CCFBrowser * broswer;
    
    UIImagePickerController *pickControl;
    
    
    NSMutableArray<UIImage*> *images;
}

@end

@implementation CCFNewThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    fId = _entry.urlId;
    broswer = [[CCFBrowser alloc]init];
    
    
    _selectPhotos.delegate = self;
    _selectPhotos.dataSource = self;
    
    
    //实例化照片选择控制器
    pickControl=[[UIImagePickerController alloc]init];
    //设置照片源
    [pickControl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    //设置协议
    pickControl.delegate = self;
    //设置编辑
    [pickControl setAllowsEditing:YES];
    //选完图片之后回到的视图界面
    
    images = [NSMutableArray array];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"imagePickerController %@", info);
    //    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    
//    UIImage *image=info[@"UIImagePickerControllerEditedImage"];
    
    UIImage * select = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [images addObject:select];
    
    
    [_selectPhotos reloadData];
    
    
//    [self.imageView setImage:image];
    
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *QuoteCellIdentifier = @"SelectPhotoCollectionViewCell";
    
    SelectPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QuoteCellIdentifier forIndexPath:indexPath];
    cell.imageView.image = images[indexPath.row];
    
    return cell;
    
}




- (IBAction)createThread:(id)sender {
    [broswer createNewThreadForForm:fId withSubject:_subject.text andMessage:_message.text];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pickPhoto:(id)sender {
    
    [self presentViewController:pickControl animated:YES completion:nil];
}
@end
