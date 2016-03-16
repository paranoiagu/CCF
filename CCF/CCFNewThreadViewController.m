//
//  CCFNewThreadViewController.m
//  CCF
//
//  Created by 迪远 王 on 16/1/13.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFNewThreadViewController.h"
#import "CCFBrowser.h"
#import "CCFApi.h"
#import "SelectPhotoCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface CCFNewThreadViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    
    
    NSString * fId;
    CCFBrowser * broswer;
    CCFApi *_api;
    
    UIImagePickerController *pickControl;
    
    
    NSMutableArray<UIImage*> *images;
}

@end

@implementation CCFNewThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    fId = _entry.urlId;
    broswer = [[CCFBrowser alloc]init];
    _api = [[CCFApi alloc] init];
    
    
    _selectPhotos.delegate = self;
    _selectPhotos.dataSource = self;
    
    
    //实例化照片选择控制器
    pickControl=[[UIImagePickerController alloc]init];
    //设置照片源
    [pickControl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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


+ (NSString*) mimeTypeForFileAtPath: (NSString *) path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    // Borrowed from http://stackoverflow.com/questions/5996797/determine-mime-type-of-nsdata-loaded-from-a-file
    // itself, derived from  http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)CFBridgingRetain([path pathExtension]), NULL);
    
    
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!mimeType) {
        return @"application/octet-stream";
    }
    
    return nil;
//    return [NSMakeCollectable((NSString *)CFBridgingRelease(mimeType)) ];
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

    //NSData * date = UIImageJPEGRepresentation(images[0], 1);
    
    NSString *title = @"客户端api容错处理【需删除】";
    NSString *message = @"容错处理";
    
    
    [_api createNewThreadWithFormId:fId withSubject:title andMessage:message withImages:nil handler:^(BOOL isSuccess, id message) {
        if (isSuccess) {
            NSLog(@"createNewThreadWithFormId %@", @"发帖成功");
        } else{
            NSLog(@"createNewThreadWithFormId %@", message);
        }
    }];

//    
//    [_api showPrivateContentById:@"2022619" handler:^(NSString* handler) {
//        NSLog(@"读取短信息具体的内容--   %@", handler);
//    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pickPhoto:(id)sender {
    
    [self presentViewController:pickControl animated:YES completion:nil];
}
@end
