/*****************************************************************
 * Copyright (c) 2013 Newegg. All rights reserved.
 *
 * Author: Sam.S.Lai
 * Create Date: 12/18/13
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "FirstScreenPageViewController.h"
//Model
#import "CDinfo.h"
#import "CDCalculate.h"

@interface FirstScreenPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *screenNumber;
@property (weak, nonatomic) IBOutlet UILabel *upDecorationLabel;
@property (weak, nonatomic) IBOutlet UILabel *downDecorationLabel;

@end

@implementation FirstScreenPageViewController{
    CDInfo *_info;
    CDCalculate *_calculate;
}

+ (id)defaultController{
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class])
                                          bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _calculate = [[CDCalculate alloc] initWithTimestamp];
        _info = _calculate.info;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (_index) {
        case 0:
            [self countdownDayPage];
            break;
        case 1:
            [self countdownPercentPage];
            break;
        case 2:
            [self countdownRetirementDayPage];
            break;
    }
}

- (void)countdownDayPage{
    self.upDecorationLabel.text = @"倒數";
    self.downDecorationLabel.text = @"天";
    self.screenNumber.text = [NSString stringWithFormat:@"%lu", (unsigned long)_info.intervalDays];
}

//#warning percent not current
- (void)countdownPercentPage{
    self.upDecorationLabel.text = @"服役完成度";
    self.downDecorationLabel.text = @"％";
    self.screenNumber.text = [NSString stringWithFormat:@"%.6f", _info.percent];
}

- (void)countdownRetirementDayPage{
    self.upDecorationLabel.text = @"退伍日期";
    self.downDecorationLabel.text = @"";
    self.screenNumber.text = [NSString stringWithFormat:@"%lu 年 %lu 月 %lu 日",
                              (unsigned long)_info.retirementYear,
                              (unsigned long)_info.retirementMonth,
                              (unsigned long)_info.retirementDay];
    self.screenNumber.font = [UIFont boldSystemFontOfSize:30.0f];
}

@end
