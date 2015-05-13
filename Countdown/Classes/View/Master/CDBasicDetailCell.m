/*****************************************************************
 * Copyright (c) 2013年 SongSheng. All rights reserved.
 *
 * Author: SongSheng
 * Create Date: 13/10/10
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "CDBasicDetailCell.h"

@implementation CDBasicDetailCell

+ (id)stringFromSelf{
    return NSStringFromClass([self class]);
}

- (void)setTitleText:(NSString *)titleText{
    _titleLabel.text = titleText;
}

- (void)addButtonAction:(SEL)action
              forTarget:(id)target{

    [_detailButton addTarget:target
                      action:action
            forControlEvents:UIControlEventTouchUpInside];
}

@end
