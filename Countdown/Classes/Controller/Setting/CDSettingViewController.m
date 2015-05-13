/*****************************************************************
 * Copyright (c) 2014 SongSheng. All rights reserved.
 *
 * Author: SongSheng
 * Create Date: 1/9/14
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "CDSettingViewController.h"
//Controller
#import "CDAboutMeViewController.h"
//View
#import "CDBasicCell.h"
#import "CDSwitchCell.h"
//Model
#import "CDInfo.h"
//Manager
#import "CDCalculate.h"

@interface CDSettingViewController () <UITableViewDataSource, UITableViewDelegate>

- (void)p_registerCell;

@end

@implementation CDSettingViewController {

    __weak IBOutlet UITableView *_settingTableView;
    CDSwitchCell        *_notificationSwitchCell;
    CDSwitchCell        *_badgeSwitchCell;
    CDInfo              *_info;
    CDCalculate         *_calculationManager;
    UILocalNotification *_localNotif;
}

+ (id)defaultController{
    return [[self alloc] initWithNibName:NSStringFromClass([self class])
                                  bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.title = @"設定";
        _calculationManager = [[CDCalculate alloc] initWithTimestamp];
        _info = _calculationManager.info;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self p_registerCell];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self localNotificationOnOrOff:_info.notificationSwitchState];
    [self hasShowBadge:_info.badgeSwitchState];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_calculationManager writeInfo:_info];
    [self localNotificationOnOrOff:_info.notificationSwitchState];
    [self hasShowBadge:_info.badgeSwitchState];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return 48.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0f;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    CDBasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:[CDBasicCell stringFromSelf]];
    UIView *viewForHeader = [[UIView alloc] initWithFrame:[basicCell frame]];
        switch (section) {
        case 0:
            [basicCell setTitleText:@"提醒"];
            [viewForHeader addSubview:basicCell];
            break;
        case 1:
            [basicCell setTitleText:@"顯示"];
            [viewForHeader addSubview:basicCell];
            break;
        case 2:
            [basicCell setTitleText:@"關於"];
            [viewForHeader addSubview:basicCell];
            break;
        case 3:
            [basicCell setTitleText:@"評論"];
            [viewForHeader addSubview:basicCell];
            break;
    }
    return viewForHeader;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 2: {
            CDAboutMeViewController *aboutMeVC = [CDAboutMeViewController defaultController];
            [self.navigationController pushViewController:aboutMeVC
                                                 animated:YES];
            break;
        }
        case 3:
            [self p_openAppStoreAlert];
            break;
    }
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"Cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case 0: {
            _notificationSwitchCell = [tableView dequeueReusableCellWithIdentifier:[CDSwitchCell stringFromSelf]];
            [_notificationSwitchCell addTarget:self
                                        action:@selector(p_didSwitchNotificationCellSwitch:)];
            [_notificationSwitchCell setNotificationTitleLabelText:@"定時提醒退伍剩餘天數"];
            _notificationSwitchCell.notificationSwitch.on = _info.notificationSwitchState;
            cell = _notificationSwitchCell;
            break;
        }
        case 1: {
            _badgeSwitchCell = [tableView dequeueReusableCellWithIdentifier:[CDSwitchCell stringFromSelf]];
            [_badgeSwitchCell addTarget:self
                                 action:@selector(p_didSwitchBadgeCellSwitch:)];
            [_badgeSwitchCell setNotificationTitleLabelText:@"在 Icon 顯示剩餘退伍天數"];
            _badgeSwitchCell.notificationSwitch.on = _info.badgeSwitchState;
            cell = _badgeSwitchCell;
            break;
        }
        case 2:
            cell.textLabel.text = @"版本資訊";
            break;
        case 3:
            cell.textLabel.text = @"評價應用程式";
            break;
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    }
    return cell;
}

#pragma mark - Private methods

- (void)p_registerCell{
    NSArray *cellArray = @[[CDSwitchCell class],
                           [CDBasicCell class]];
    for (Class class in cellArray) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([class class])
                                    bundle:nil];
        [_settingTableView registerNib:nib
                forCellReuseIdentifier:NSStringFromClass([class class])];
    }
}

- (void)p_openAppStoreAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:@"You will leave this app"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Leave", nil];
    [alert show];
}

- (void)p_didSwitchNotificationCellSwitch:(UISwitch *)notificationCellSwitch{
    _info.notificationSwitchState = notificationCellSwitch.on;
    [self localNotificationOnOrOff:_info.notificationSwitchState];
    NSString *message = (notificationCellSwitch.on) ? @"on" : @"off";
    NSLog(@"Notification switch is %@", message);
    [_calculationManager writeInfo:_info];
}

- (void)p_didSwitchBadgeCellSwitch:(UISwitch *)badgeCellSwitch{
    _info.badgeSwitchState = badgeCellSwitch.on;
    [self hasShowBadge:_info.badgeSwitchState];
    NSString *message =  (badgeCellSwitch.on) ? @"on" : @"off";
    NSLog(@"Badge Switch is %@", message);
    [_calculationManager writeInfo:_info];
}

#pragma mark - Local Notification

- (void)localNotificationOnOrOff:(BOOL)onOrOff{
    if (onOrOff == YES) {
        [self localNotificationOn];
    } else {
        [self localNotificationOff];
    }
}

- (void)localNotificationOn{
    _localNotif = [[UILocalNotification alloc] init];
    if (_localNotif){
        NSDateComponents *component = [[NSDateComponents alloc] init];
        [component setMinute:15];
        [component setSecond:18];
        _localNotif.fireDate = [[NSCalendar currentCalendar] dateFromComponents:component];
        _localNotif.timeZone = [NSTimeZone defaultTimeZone];
        _localNotif.repeatInterval = NSMinuteCalendarUnit;
        _localNotif.alertAction = @"Countdown";
        _localNotif.alertBody = [NSString stringWithFormat:@"Countdown %lu days", (unsigned long)_info.intervalDays];
        _localNotif.applicationIconBadgeNumber = _info.intervalDays;
        [[UIApplication sharedApplication] scheduleLocalNotification:_localNotif];
    }
}

- (void)localNotificationOff{
    if (_localNotif) [[UIApplication sharedApplication] cancelLocalNotification:_localNotif];
}

#pragma mark - Show Badge

- (void)hasShowBadge:(BOOL)showBadge{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:(showBadge == YES) ? _info.intervalDays : 0];
}

@end
