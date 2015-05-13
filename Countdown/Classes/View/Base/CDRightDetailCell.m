/*****************************************************************
 * Copyright (c) 2013年 SongSheng. All rights reserved.
 *
 * Author: SongSheng
 * Create Date: 13/9/5
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "CDRightDetailCell.h"

@interface CDRightDetailCell () {
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *detailLabel;
}

@end

@implementation CDRightDetailCell

+ (id)stringFromSelf{
    return NSStringFromClass([self class]);
}

- (void)setTitleText:(NSString *)titleText
     andSubtitleText:(NSString *)detailText{
    titleLabel.text = titleText;
    detailLabel.text = detailText;
}

@end
