/*****************************************************************
 * Copyright (c) 2013 SongSheng. All rights reserved.
 *
 * Author: SongSheng
 * Create Date: 12/12/13
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "CDInfo.h"

NSString *const LSSEnlistmentDate = @"EnlistmentDate";
NSString *const LSSIntervalDays = @"IntervalDays";
NSString *const LSSIntervalHours = @"IntervalHours";
NSString *const LSSIntervalMinutes = @"IntervalMinutes";
NSString *const LSSIntervalSeconds = @"IntervalSeconds";
NSString *const LSSCreditedDuration = @"CreditDuration";
NSString *const LSSDiscontinueDuration = @"DiscontinueDuration";
NSString *const LSSRetirementYear = @"RetirementYear";
NSString *const LSSRetirementMonth = @"RetirementMonth";
NSString *const LSSRetirementDay = @"RetirementDay";
NSString *const LSSPercent = @"Percent";
NSString *const LSSQualificationStatus = @"QualificationStatus";
NSString *const LSSCountdownDefaultInfo = @"CountdownDefaultInfo";
NSString *const LSSNotificationSwitchState = @"NotificationSwitchState";
NSString *const LSSBadgeSwitchState = @"BadgeSwitchState";
NSUInteger const kOneDayDuration = 86400;
NSUInteger const kNormalOneYearDuration = 31536000;
NSUInteger const kStandingOneYearDuration = 32832000;

#define oneYearDuration (_qualificationStatus == QualificationOfStanding) ? kStandingOneYearDuration : kNormalOneYearDuration

typedef NS_ENUM (NSInteger, Qualification) {
    QualificationOfStanding = 0
};

@interface CDInfo () <NSCoding>

- (void)p_intervalWithEnrollDay;
- (void)p_calculationPercent;
- (void)p_calculationDate;
- (NSDateComponents *)p_dateComponentsDesignatedAsNoon;
- (NSDate *)p_pickerCurrentDate;
- (NSTimeInterval)p_oneYearInterval;

@end

@implementation CDInfo{
    NSUInteger      _discontinueDuration;
    NSUInteger      _creditedDuration;
    NSTimeInterval  _oneYearInterval;
    NSUInteger      _oneYearDurantion;
}

- (id)init{
    self = [super init];
    if (self) {
        _enlistmentDate = [NSDate date];
        _intervalDays = 364;
        _intervalHours = 24;
        _intervalMinutes = 59;
        _intervalSeconds = 59;
        _creditedDuration = 0;
        _discontinueDuration = 0;
        _retirementYear = 2000;
        _retirementMonth = 8;
        _retirementDay = 20;
        _percent = 0;
        _qualificationStatus = QualificationStatusOfStanding;
        _notificationSwitchState = YES;
        _badgeSwitchState = YES;
        _oneYearInterval = [self p_oneYearInterval]; // 正確的一年間隔時間
        [self p_intervalWithEnrollDay];
        [self p_calculationDate];
        [self p_calculationPercent];
    }
    return self;
}

- (id)initWithInfo:(CDInfo *)info{
    if (!info) {
        return [self init];
    } else {
        _enlistmentDate = info.enlistmentDate;
        _intervalDays = info.intervalDays;
        _intervalHours = info.intervalHours;
        _intervalMinutes = info.intervalMinutes;
        _intervalSeconds = info.intervalSeconds;
        _creditedDuration = info.creditedDuration;
        _discontinueDuration = info.discontinueDuration;
        _retirementYear = info.retirementYear;
        _retirementMonth = info.retirementMonth;
        _retirementDay = info.retirementDay;
        _percent = info.percent;
        _qualificationStatus = info.qualificationStatus;
        _notificationSwitchState = info.notificationSwitchState;
        _badgeSwitchState = info.badgeSwitchState;
        _discontinueDuration = kOneDayDuration * info.discontinueDuration; // 停役期間
        _creditedDuration = kOneDayDuration * info.creditedDuration; // 折抵期間
        _oneYearInterval = [self p_oneYearInterval]; // 正確的一年間隔時間
        [self p_intervalWithEnrollDay];
        [self p_calculationDate];
        [self p_calculationPercent];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_enlistmentDate forKey:LSSEnlistmentDate];
    [aCoder encodeInteger:_intervalDays forKey:LSSIntervalDays];
    [aCoder encodeInteger:_intervalHours forKey:LSSIntervalHours];
    [aCoder encodeInteger:_intervalMinutes forKey:LSSIntervalMinutes];
    [aCoder encodeInteger:_intervalSeconds forKey:LSSIntervalSeconds];
    [aCoder encodeInteger:_creditedDuration forKey:LSSCreditedDuration];
    [aCoder encodeInteger:_discontinueDuration forKey:LSSDiscontinueDuration];
    [aCoder encodeInteger:_retirementYear forKey:LSSRetirementYear];
    [aCoder encodeInteger:_retirementMonth forKey:LSSRetirementMonth];
    [aCoder encodeInteger:_retirementDay forKey:LSSRetirementDay];
    [aCoder encodeFloat:_percent forKey:LSSPercent];
    [aCoder encodeInteger:_qualificationStatus forKey:LSSQualificationStatus];
    [aCoder encodeBool:_notificationSwitchState forKey:LSSNotificationSwitchState];
    [aCoder encodeBool:_badgeSwitchState forKey:LSSBadgeSwitchState];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _enlistmentDate = [aDecoder decodeObjectForKey:LSSEnlistmentDate];
        _intervalDays = [aDecoder decodeIntegerForKey:LSSIntervalDays];
        _intervalHours = [aDecoder decodeIntegerForKey:LSSIntervalHours];
        _intervalMinutes = [aDecoder decodeIntegerForKey:LSSIntervalMinutes];
        _intervalSeconds = [aDecoder decodeIntegerForKey:LSSIntervalSeconds];
        _creditedDuration = [aDecoder decodeIntegerForKey:LSSCreditedDuration];
        _discontinueDuration = [aDecoder decodeIntegerForKey:LSSDiscontinueDuration];
        _retirementYear = [aDecoder decodeIntegerForKey:LSSRetirementYear];
        _retirementMonth = [aDecoder decodeIntegerForKey:LSSRetirementMonth];
        _retirementDay = [aDecoder decodeIntegerForKey:LSSRetirementDay];
        _percent = [aDecoder decodeFloatForKey:LSSPercent];
        _qualificationStatus = [aDecoder decodeIntegerForKey:LSSQualificationStatus];
        _notificationSwitchState = [aDecoder decodeBoolForKey:LSSNotificationSwitchState];
        _badgeSwitchState = [aDecoder decodeBoolForKey:LSSBadgeSwitchState];
    }
    return self;
}

- (CDInfo *)calculateIntervalWithTimer:(NSTimer *)timer{
    if (!timer) {
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(p_intervalWithEnrollDay)
                                       userInfo:nil
                                        repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(p_calculationPercent)
                                       userInfo:nil
                                        repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:3600.0f
                                         target:self
                                       selector:@selector(p_calculationDate)
                                       userInfo:nil
                                        repeats:YES];
    }
    return self;
}

#pragma mark - Private methods

- (NSDateComponents *)p_dateComponentsDesignatedAsNoon{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSYearCalendarUnit
                                    | NSMonthCalendarUnit
                                    | NSDayCalendarUnit
                                    | NSHourCalendarUnit
                                    | NSMinuteCalendarUnit
                                    | NSSecondCalendarUnit
                                                                   fromDate:(_enlistmentDate) ? _enlistmentDate : [NSDate date]];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    return components;
}

- (NSDate *)p_pickerCurrentDate{
    return [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:[self p_dateComponentsDesignatedAsNoon]];
}

- (NSTimeInterval)p_oneYearInterval{
    NSUInteger correctOneYearDuration = oneYearDuration + _discontinueDuration - _creditedDuration;
    NSDate *afterOneYear = [[self p_pickerCurrentDate] dateByAddingTimeInterval:correctOneYearDuration];
    return [afterOneYear timeIntervalSinceNow];
}

#pragma mark - Calculate
#pragma mark - Calculate interval

- (void)p_intervalWithEnrollDay{
    @autoreleasepool {
        if ([self p_oneYearInterval] > 0) {

            BOOL checkDuration = ((_oneYearInterval / 86400) > oneYearDuration);

            div_t d = div(_oneYearInterval, kOneDayDuration);
            _intervalDays = checkDuration ? oneYearDuration : d.quot;

            div_t h = div(d.rem, 3600); // one hour seconds
            _intervalHours = checkDuration ? 24 : h.quot;

            div_t m = div(h.rem, 60); // one minute seconds
            _intervalMinutes = checkDuration ? 60 : m.quot;

            div_t s = div(m.rem, 1); // one second
            _intervalSeconds = checkDuration ? 60 : s.quot;
        } else {
            _intervalDays = _intervalHours = _intervalMinutes = _intervalSeconds = 0;
        }
    }
}

#pragma mark - Calculate percent

- (void)p_calculationPercent{
    @autoreleasepool {
        CGFloat oneYearTime = oneYearDuration;
        CGFloat oneYearInt = (CGFloat)_oneYearInterval;
        CGFloat percent = 0.0f;
        if (100.0f - (oneYearInt / oneYearTime * 100.0f) > 100.0f) {
            percent = 100.0f;
        } else if (100.0f - (oneYearInt / oneYearTime * 100.0f) < 0.0f) {
            percent = 0.0f;
        } else {
            percent = (100.0f - (oneYearInt / oneYearTime * 100.0f));
        }
        _percent = percent;
    }
}

#pragma mark - Calculate retirement Date

- (void)p_calculationDate{
    @autoreleasepool {
        NSTimeInterval countdown = oneYearDuration - _creditedDuration + _discontinueDuration;
        NSDate *retirementDate = [NSDate dateWithTimeInterval:countdown
                                                    sinceDate:(_enlistmentDate) ? _enlistmentDate : [NSDate date]];

        NSDateComponents *comps = [[NSCalendar currentCalendar] components:
                                   NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit
                                                                  fromDate:retirementDate];
        _retirementYear = [comps year];
        _retirementMonth = [comps month];
        _retirementDay = [comps day];
    }
}

@end
