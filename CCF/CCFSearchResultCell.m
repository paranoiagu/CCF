//
//  CCFSearchResultCell.m
//  CCF
//
//  Created by WDY on 16/1/11.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFSearchResultCell.h"
#import "CCFSearchResult.h"


@implementation CCFSearchResultCell{
    CCFSearchResult *_result;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSearchResult:(CCFSearchResult *)result{
    if (_result != result) {
        _result = result;
        
        _postTitle.text = _result.threadTitle;
        _postAuthor.text = _result.threadAuthor;
        _postTime.text = _result.threadCreateTime;
        _postBelongForm.text = _result.threadBelongForm;
    }
}


@end
