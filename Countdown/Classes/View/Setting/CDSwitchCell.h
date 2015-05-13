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

#import <UIKit/UIKit.h>

@interface CDSwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

+ (id)stringFromSelf;
- (void)setNotificationTitleLabelText:(NSString *)titleLabelText;
- (void)addTarget:(id)target action:(SEL)action;

@end
