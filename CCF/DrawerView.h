//
//  LeftDrawerView.h
//  iOSMaps
//
//  Created by WDY on 15/12/8.
//  Copyright © 2015年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewDelegate.h"
#import "LeftDrawerItem.h"


typedef CGFloat(^TouchX) (CGFloat x, CGFloat maxX);


typedef NS_ENUM(NSInteger, DrawerViewType) {
    DrawerViewTypeLeft = 0,                         // left
    DrawerViewTypeRight,
    DrawerViewTypeLeftAndRight

};

typedef NS_ENUM(NSInteger, DrawerIndex) {
    DrawerIndexLeft = 0,                         // left
    DrawerIndexRight,
};

@interface DrawerView : UIView{

}

@property (nonatomic, weak) id<DrawerViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *leftDrawerView;
@property (strong, nonatomic) IBOutlet UIView *rightDrawerView;


@property (nonatomic, assign) BOOL leftDrawerOpened;
@property (nonatomic, assign) BOOL leftDrawerEnadbled;

@property (nonatomic, assign) BOOL rightDrawerOpened;
@property (nonatomic, assign) BOOL rightDrawerEnadbled;


@property (nonatomic, assign) DrawerViewType drawerType;

-(UIView *) findDrawerWithDrawerIndex:(DrawerIndex)type;

-(id)initWithDrawerType:(DrawerViewType)drawerType;

-(id)initWithDrawerType:(DrawerViewType)drawerType andXib:(NSString *)name;

-(id)init;

-(void)openLeftDrawer;
-(void)closeLeftDrawer;

-(void)openRightDrawer;
-(void)closeRightDrawer;

- (IBAction)showMyFavForm:(id)sender;
- (IBAction)showMessage:(id)sender;
- (IBAction)showFavThread:(id)sender;
- (IBAction)showNewThread:(id)sender;
- (IBAction)showMyPost:(id)sender;
- (IBAction)showMyThread:(id)sender;
- (IBAction)showAllForms:(id)sender;
- (IBAction)showTodayNewThreadPost:(LeftDrawerItem *)sender;

- (IBAction)showMyProfile:(id)sender;

@property (weak, nonatomic) IBOutlet LeftDrawerItem *favForm;
@property (weak, nonatomic) IBOutlet LeftDrawerItem *allForm;
@property (weak, nonatomic) IBOutlet LeftDrawerItem *message;
@property (weak, nonatomic) IBOutlet LeftDrawerItem *favThread;
@property (weak, nonatomic) IBOutlet LeftDrawerItem *showNewThread;
@property (weak, nonatomic) IBOutlet LeftDrawerItem *myPost;
@property (weak, nonatomic) IBOutlet LeftDrawerItem *myThread;
@property (weak, nonatomic) IBOutlet LeftDrawerItem *todayNewThreadPost;


@property (weak, nonatomic) IBOutlet UIImageView *avatarUIImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;


@end
