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

#import <UIKit/UIKit.h>

@interface CDRightDetailCell : UITableViewCell

+ (id)stringFromSelf;
- (void)setTitleText:(NSString *)titleText
     andSubtitleText:(NSString *)subtitleText;

@end
