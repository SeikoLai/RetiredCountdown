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

#import "CDRetirementDateCell.h"

@interface CDRetirementDateCell () {
    __weak IBOutlet UILabel *_yearLabel;
    __weak IBOutlet UILabel *_monthLabel;
    __weak IBOutlet UILabel *_dayLabel;
}

@end

@implementation CDRetirementDateCell

+ (id)stringFromSelf{
    return NSStringFromClass([self class]);
}

- (void)fillWithInfo:(CDInfo *)info{
    _dayLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.retirementDay];
    _monthLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.retirementMonth];
    _yearLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.retirementYear];
}

@end
