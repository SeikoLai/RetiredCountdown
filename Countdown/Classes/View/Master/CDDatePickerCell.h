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

@protocol CDDatePickerCellDelegate;

@interface CDDatePickerCell : UITableViewCell

@property (weak, nonatomic) id <CDDatePickerCellDelegate> delegate;
@property (strong, nonatomic) UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIView *slidePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *staticDatePickerView;

+ (id)stringFromSelf;
- (void)addPickerTarget:(id)aTarget
              andAction:(SEL)aAction;

@end

@protocol CDDatePickerCellDelegate <NSObject>

- (void)selectedDate:(NSDate *)date;
- (void)creditedInfo:(UIPickerView *)sender;

@end
