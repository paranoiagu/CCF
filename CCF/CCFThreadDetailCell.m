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

@interface CCFThreadDetailCell ()

@end

@implementation CCFThreadDetailCell

- (void)awakeFromNib {

    _htmlView.shouldDrawImages = NO;
    _htmlView.shouldDrawLinks = NO;
    _htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(CCFPost *)newPost {
    
    if (_post != newPost) {
        _post = newPost;
        NSString * html = self.post.postContent;
//        [self.htmlView loadHTMLString:html baseURL:[CCFUrlBuilder buildIndexURL]];
        _htmlView.attributedString = [self showHtml:html];
    }
}

- (NSAttributedString *)showHtml:(NSString *)html{
    // Load HTML data
    //    NSString *readmePath = [[NSBundle mainBundle] pathForResource:_fileName ofType:nil];
    //    NSString *html = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(self.window.bounds.size.width - 20.0, self.window.bounds.size.height - 20.0);
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                    @"Times New Roman", DTDefaultFontFamily,  @"purple", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor, callBackBlock, DTWillFlushBlockCallBack, nil];
    
    
    //[options setObject:[NSURL fileURLWithPath:readmePath] forKey:NSBaseURLDocumentOption];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    return string;
}

@end
