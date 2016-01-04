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

@interface CCFThreadDetailCell ()<DTAttributedTextContentViewDelegate>{
    
    NSIndexPath *path;
}

@end

@implementation CCFThreadDetailCell

- (void)awakeFromNib {

    _htmlView.shouldDrawImages = NO;
    _htmlView.shouldDrawLinks = NO;
    
    _htmlView.delegate = self;
    
    _htmlView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _htmlView.relayoutMask = DTAttributedTextContentViewRelayoutOnHeightChanged | DTAttributedTextContentViewRelayoutOnWidthChanged;
    
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

-(void)setPost:(CCFPost *)post with:(NSIndexPath *)indexPath{
    path = indexPath;
    [self setPost:post];
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

#pragma mark DTAttributedTextContentViewDelegate
-(void)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView willDrawLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame inContext:(CGContextRef)context{
    CGSize size = [attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:layoutFrame.frame.size.width];
    
    
    //NSLog(@"attributedTextContentView----------->>  %f %f", size.width, size.height);
    
    
    CGRect frame = _htmlView.frame;
    frame.size.height = size.height;
    _htmlView.frame = frame;
    
    
    
    NSLog(@"attributedTextContentView----------->>   %f %f       //     %f %f", size.width, size.height , frame.size.width, frame.size.height);
    
    CGRect cellframe = self.frame;
    
    NSLog(@"attributedTextContentView----------->>   %f %f \n\t", cellframe.size.width, cellframe.size.height);
    
    [self.delegate relayoutContentHeigt:path with:size.height];
}

-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(size.width, self.frame.size.height);
}
@end
