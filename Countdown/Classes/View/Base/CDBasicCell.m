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

#import "CDBasicCell.h"

@interface CDBasicCell () {
    
    __weak IBOutlet UILabel *titleLabel;
}

@end

@implementation CDBasicCell

+ (id)stringFromSelf{
    return NSStringFromClass([self class]);
}

- (void)setTitleText:(NSString *)titleText{
    titleLabel.text = titleText;
}

@end
