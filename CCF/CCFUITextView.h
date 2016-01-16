//
//  CCFUITextView.h
//  CCF
//
//  Created by WDY on 16/1/8.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMiniHeight 30
#define kMaxHeight  180

@protocol CCFUITextViewDelegate <NSObject>

@required
-(void)heightChanged:(CGFloat) height;

@end


@interface CCFUITextView : UITextView

@property (nonatomic, strong) id<CCFUITextViewDelegate> heightDelegate;


-(void) showPlaceHolder:(BOOL) show;

@end
