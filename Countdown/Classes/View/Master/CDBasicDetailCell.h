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

#import <UIKit/UIKit.h>

@interface CDBasicDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (id)stringFromSelf;
- (void)setTitleText:(NSString *)titleText;
- (void)addButtonAction:(SEL)action
              forTarget:(id)target;

@end
