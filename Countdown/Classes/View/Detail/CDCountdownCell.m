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


#import "CDCountdownCell.h"

@interface CDCountdownCell () {
    
    __weak IBOutlet UILabel *_dayLabel;
    __weak IBOutlet UILabel *_hourLabel;
    __weak IBOutlet UILabel *_minuteLabel;
    __weak IBOutlet UILabel *_secondLabel;
}

@end

@implementation CDCountdownCell

+ (id)stringFromSelf{
    return NSStringFromClass([self class]);
}

- (void)fillWithInfo:(CDInfo *)info{
    _dayLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.intervalDays];
    _hourLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.intervalHours];
    _minuteLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.intervalMinutes];
    _secondLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.intervalSeconds];
}

@end
