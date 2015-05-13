/*****************************************************************
 * Copyright (c) 2014 SongSheng. All rights reserved.
 *
 * Author: SongSheng
 * Create Date: 1/16/14
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "CDSwitchCell.h"

@interface CDSwitchCell () {
    
    __weak IBOutlet UILabel *notificationTitleLabel;
    __weak IBOutlet UISwitch *switchButton;
}

@end

@implementation CDSwitchCell

+ (id)stringFromSelf{
    return NSStringFromClass([self class]);
}

- (void)setNotificationTitleLabelText:(NSString *)titleLabelText{
    notificationTitleLabel.text = titleLabelText;
}

- (void)addTarget:(id)target action:(SEL)action{
    [switchButton addTarget:target
                     action:action
           forControlEvents:UIControlEventValueChanged];
}

@end
