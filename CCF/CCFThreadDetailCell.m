//
//  CCFThreadDetailCell.m
//  CCF
//
//  Created by 迪远 王 on 16/1/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadDetailCell.h"
#import "CCFUrlBuilder.h"
#import "CCFPost.h"

@interface CCFThreadDetailCell ()<UIWebViewDelegate>

@end

@implementation CCFThreadDetailCell

- (void)awakeFromNib {

    
    _content.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(CCFPost *)newPost {
    
    if (_post != newPost) {
        _post = newPost;
        NSString * html = self.post.postContent;
        [self.content loadHTMLString:html baseURL:[CCFUrlBuilder buildIndexURL]];
    }
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGRect frame = webView.frame;
    
    frame.size = [webView sizeThatFits:CGSizeZero];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];

    
    NSLog(@"webViewDidFinishLoad     %f", height );
    
}

@end
