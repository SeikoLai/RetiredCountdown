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

#import "CDDetailViewController.h"
//Framework
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
//Controller
#import "CDSettingViewController.h"
//View
#import "CDBasicCell.h"
#import "CDCountdownCell.h"
#import "CDPercentCell.h"
#import "CDRetirementDateCell.h"
//Manager
#import "CDCalculate.h"

#define ONE_YEAR_TIME_SECONDS (_info.qualificationStatus == QualificationOfStanding) ? STANDING_ONE_YEAR_SECONDS : NORMAL_ONE_YEAR_SECONDS

typedef NS_ENUM (NSInteger, SectionHeader) {
    SectionHeaderOfCountdown        = 0,
    SectionHeaderOfPercent          = 1,
    SectionHeaderOfRetirementDate   = 2,
    SectionHeaderOfShare            = 3
};

typedef NS_ENUM (NSInteger, Countdown) {
    CountdownCell = 0
};

typedef NS_ENUM (NSInteger, Percent) {
    PercentCell = 0
};

typedef NS_ENUM (NSInteger, RetirementDate) {
    RetirementDateCell = 0
};

typedef NS_ENUM (NSInteger, Qualification) {
    QualificationOfStanding = 0
};

@interface CDDetailViewController () <UITableViewDelegate, UITableViewDataSource>

- (IBAction)shareButtonPressed:(id)sender;

@end

@implementation CDDetailViewController{
    __weak IBOutlet UITableView *_detailTableView;
    NSTimer                 *_reloadRowTimer;
    BOOL                    _success;
    CDRetirementDateCell    *_retirementDateCell;
    CDCalculate             *_calculationManager;
    CDInfo                  *_info;
}

+ (id)defaultController{
    return [[self alloc] initWithNibName:NSStringFromClass([self class])
                                          bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"退伍倒數計算器";
        [self infoButtonOfRightBarButtonItem];
        _calculationManager = [[CDCalculate alloc] initWithTimestamp];
        _info = _calculationManager.info;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self registerCell];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self timerStart];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_calculationManager writeInfo:_info];
    [self timerStop];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return (section == 3) ? 0.0f : 48.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section == 3) ? 48.0f : 104.0f;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    
    CDBasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:[CDBasicCell stringFromSelf]];;
    UIView *view = [[UIView alloc] initWithFrame:[basicCell frame]];
    switch (section) {
        case SectionHeaderOfCountdown:
            [basicCell setTitleText:@"退伍剩餘時間"];
            break;
        case SectionHeaderOfPercent:
            [basicCell setTitleText:@"服役完成度"];
            break;
        case SectionHeaderOfRetirementDate:
            [basicCell setTitleText:@"退伍日期"];
            break;
    }
    [view addSubview:basicCell];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell         *cell;
    CDInfo *info = [[CDInfo alloc] initWithInfo:_info];
    
    switch (indexPath.section) {
        case SectionHeaderOfCountdown: {
            CDCountdownCell *countdownCell = [tableView dequeueReusableCellWithIdentifier:[CDCountdownCell stringFromSelf]];
            [countdownCell fillWithInfo:[info calculateIntervalWithTimer:_reloadRowTimer]];
            cell = countdownCell;
            break;
        }
        case SectionHeaderOfPercent: {
            CDPercentCell *percentCell = [tableView dequeueReusableCellWithIdentifier:[CDPercentCell stringFromSelf]];
            [percentCell fillWithInfo:[info calculateIntervalWithTimer:_reloadRowTimer]];
            cell = percentCell;
            break;
        }
        case SectionHeaderOfRetirementDate: {
            _retirementDateCell = [tableView dequeueReusableCellWithIdentifier:[CDRetirementDateCell stringFromSelf]];
            [_retirementDateCell fillWithInfo:[info calculateIntervalWithTimer:_reloadRowTimer]];
            cell = _retirementDateCell;
            break;
        }
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    }
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Method

- (void)registerCell{
    NSArray *cellArray = @[[CDBasicCell class],
                           [CDCountdownCell class],
                           [CDPercentCell class],
                           [CDRetirementDateCell class]];
    for (Class class in cellArray) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([class class])
                                    bundle:nil];
        [_detailTableView registerNib:nib
               forCellReuseIdentifier:NSStringFromClass([class class])];
    }
}

- (void)reloadRow{
    NSArray *needReloadRowsIndexPath = @[[NSIndexPath indexPathForRow:CountdownCell
                                                            inSection:SectionHeaderOfCountdown],
                                         [NSIndexPath indexPathForRow:PercentCell
                                                            inSection:SectionHeaderOfPercent],
                                         [NSIndexPath indexPathForRow:RetirementDateCell
                                                            inSection:SectionHeaderOfRetirementDate]];
    [_detailTableView beginUpdates];
    [_detailTableView reloadRowsAtIndexPaths:needReloadRowsIndexPath
                            withRowAnimation:UITableViewRowAnimationNone];
    [_detailTableView endUpdates];
}

- (void)timerStart{
    if (!_reloadRowTimer) {
        _reloadRowTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                           target:self
                                                         selector:@selector(reloadRow)
                                                         userInfo:nil
                                                          repeats:YES];

    }
}

- (void)timerStop{
    [_reloadRowTimer invalidate];
    _reloadRowTimer = nil;
}

#pragma mark - Share Task
- (NSArray *)activityItems{
    NSString *shareString = [NSString stringWithFormat:@"朋友們，我還有%lu天就退伍了，準備開 PARTY 囉！", (unsigned long)_info.intervalDays];
    return @[shareString];
}

- (NSArray *)applictionActivities{
    return @[UIActivityTypePostToFacebook,
             UIActivityTypePostToFlickr,
             UIActivityTypePostToTencentWeibo,
             UIActivityTypePostToTwitter,
             UIActivityTypePostToVimeo,
             UIActivityTypePostToWeibo,
             UIActivityTypeMessage,
             UIActivityTypeMail];
}

- (void)share{
    NSArray *activityItems = [self activityItems];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                      applicationActivities:nil];
    avc.excludedActivityTypes = @[UIActivityTypeAirDrop,
                                  UIActivityTypeAssignToContact,
                                  UIActivityTypeCopyToPasteboard,
                                  UIActivityTypePrint,
                                  UIActivityTypeSaveToCameraRoll];
    [self presentViewController:avc animated:YES completion:nil];
}

- (IBAction)shareButtonPressed:(id)sender{
    [self share];
}

#pragma mark - Info Button

- (void)infoButtonOfRightBarButtonItem{
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self
                   action:@selector(infoButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - Info Button Pressed

- (void)infoButtonPressed{
    [_calculationManager writeInfo:_info];
    CDSettingViewController *settingVC = [CDSettingViewController defaultController];
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end
