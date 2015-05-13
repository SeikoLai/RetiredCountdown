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

#import "CDDatePickerCell.h"
//Model
#import "CDInfo.h"

@interface CDDatePickerCell () <UIPickerViewDataSource, UIPickerViewDelegate> 

@end

@implementation CDDatePickerCell{
    CDInfo *_info;
}

+ (id)stringFromSelf{
    return NSStringFromClass([self class]);
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:LSSCountdownDefaultInfo]) {
            _info = [[CDInfo alloc] init];
            [_staticDatePickerView setDate:_info.enlistmentDate ? _info.enlistmentDate : [NSDate date]];
        }
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _picker = [[UIPickerView alloc] init];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    [_picker selectRow:(_info.creditedDuration) ? _info.creditedDuration : 0
           inComponent:0
              animated:NO];
    [_picker selectRow:(_info.discontinueDuration) ? _info.discontinueDuration : 0
           inComponent:1
              animated:NO];
    [_slidePickerView addSubview:_picker];
}

- (void)addPickerTarget:(id)aTarget
              andAction:(SEL)aAction{
    [_staticDatePickerView addTarget:aTarget
                              action:aAction
                    forControlEvents:UIControlEventValueChanged];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return 31;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    NSMutableArray *days = [NSMutableArray array];
    for (int i = 0 ; i < 31 ; i++) {
        [days addObject:[NSString stringWithFormat:@"%i", i]];
    }
    return [days objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    [_delegate creditedInfo:pickerView];
}

@end
