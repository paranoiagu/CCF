//
//  CCFSeniorNewPostViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/16.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSeniorNewPostViewController.h"

#import "SelectPhotoCollectionViewCell.h"
#import "TransValueDelegate.h"
#import "CCFThread.h"
#import "CCFPost.h"
#import "TransValueBundle.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface CCFSeniorNewPostViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DeleteDelegate, TransValueDelegate>{
    
    UIImagePickerController *pickControl;
    NSMutableArray<UIImage*> *images;
    TransValueBundle * bundle;
}

@end

@implementation CCFSeniorNewPostViewController




-(void)transValue:(id)value{
    bundle = value;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _insertCollectionView.delegate = self;
    _insertCollectionView.dataSource = self;

    //实例化照片选择控制器
    pickControl=[[UIImagePickerController alloc]init];

    //设置协议
    pickControl.delegate = self;
    //设置编辑
    [pickControl setAllowsEditing:NO];
    //选完图片之后回到的视图界面
    
    images = [NSMutableArray array];
    
}


- (long long) fileSizeAtPathWithString:(NSString*) filePath{
    
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void) fileSizeAtPath:(NSURL*) filePath{
    //return [self fileSizeAtPathWithString:filePath.path];
    ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
    __block long long fileSize  = 0.0;
    
    [alLibrary assetForURL:filePath resultBlock:^(ALAsset *asset){
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        
        fileSize = [representation size];
        
        
        NSLog(@"图片大小:   %lld", fileSize);
        
    }failureBlock:nil];
    
}


- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}



#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"imagePickerController %@", info);
    //    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    
    //    UIImage *image=info[@"UIImagePickerControllerEditedImage"];
    
    UIImage * select = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSURL * selectUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSData * date = UIImageJPEGRepresentation(select, 1.0);
    
    
    NSLog(@"----------&&&&&&&    %@", [self contentTypeForImageData:date]);
    
    [self fileSizeAtPath:selectUrl];
    
    
    [images addObject:select];
    
    
    [_insertCollectionView reloadData];
    
    
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


-(void)deleteCurrentImageForIndexPath:(NSIndexPath *)indexPath{
    [images removeObjectAtIndex:indexPath.row];
    [self.insertCollectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"CCFSeniorNewPostViewControllerCell";
    
    SelectPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.deleteImageDelete = self;
    
    [cell setData:images[indexPath.row] forIndexPath:indexPath];
    
    return cell;
    
}

- (IBAction)insertSmile:(id)sender {
    
}

- (IBAction)insertPhoto:(id)sender {
    UIAlertController * insertPhotoController = [UIAlertController alertControllerWithTitle:@"添加图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //设置照片源
        [pickControl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self presentViewController:pickControl animated:YES completion:nil];
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //设置照片源
        [pickControl setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [self presentViewController:pickControl animated:YES completion:nil];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    
    [insertPhotoController addAction:photo];
    [insertPhotoController addAction:camera];
    [insertPhotoController addAction:cancel];
    
    [self presentViewController:insertPhotoController animated:YES completion:nil];

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendSeniorMessage:(UIBarButtonItem *)sender {
    int threadId = [bundle getIntValue:@"THREAD_ID"];
    int postId = [bundle getIntValue:@"POST_ID"];
    NSString * securityToken = [bundle getStringValue:@"SECYRITY_TOKEN"];
    NSString * ajaxLastPost = [bundle getStringValue:@"AJAX_LAST_POST"];
    [self.ccfApi quickReplyPostWithThreadId:threadId forPostId:postId andMessage:self.replyContent.text securitytoken:securityToken ajaxLastPost:ajaxLastPost handler:^(BOOL isSuccess, id message) {
        NSString * html = message;
    }];
}
@end
