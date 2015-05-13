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


#import <UIKit/UIKit.h>
//Model
#import "CDInfo.h"

@interface CDPercentCell : UITableViewCell

+ (id)stringFromSelf;
- (void)fillWithInfo:(CDInfo *)info;

@end
