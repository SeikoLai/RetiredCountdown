/*****************************************************************
 * Copyright (c) 2013年 SongSheng. All rights reserved.
 *
 * Author: SongSheng
 * Create Date: 13/8/10
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "CDPercentCell.h"

@interface CDPercentCell () {
    __weak IBOutlet UILabel *percentLabel;
}

@end

@implementation CDPercentCell

+ (id)stringFromSelf{
    return NSStringFromClass([self class]);
}

- (void)fillWithInfo:(CDInfo *)info{
    percentLabel.text = [NSString stringWithFormat:@"%.3f", info.percent];
}

@end
