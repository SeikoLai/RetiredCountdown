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

#import <Foundation/Foundation.h>

extern NSString *const LSSEnlistmentDate;
extern NSString *const LSSIntervalDays;
extern NSString *const LSSIntervalHours;
extern NSString *const LSSIntervalMinutes;
extern NSString *const LSSIntervalSeconds;
extern NSString *const LSSCreditedDuration;
extern NSString *const LSSDiscontinueDuration;
extern NSString *const LSSRetirementYear;
extern NSString *const LSSRetirementMonth;
extern NSString *const LSSRetirementDay;
extern NSString *const LSSPercent;
extern NSString *const LSSQualificationStatus;
extern NSString *const LSSCountdownDefaultInfo;
extern NSString *const LSSNotificationSwitchState;
extern NSString *const LSSBadgeSwitchState;
extern NSUInteger const kOneDayDuration;
extern NSUInteger const kNormalOneYearDuration;
extern NSUInteger const kStandingOneYearDuration;

typedef NS_ENUM (NSInteger, QualificationStatus) {
    QualificationStatusOfStanding               = 0,
    QualificationStatusOfSubstituteStatus       = 1,
    QualificationStatusOfFamilyFactorsStatus    = 2
};

@interface CDInfo : NSObject

@property (strong, nonatomic) NSDate *enlistmentDate;
@property (assign, nonatomic) NSUInteger intervalDays;
@property (assign, nonatomic) NSUInteger intervalHours;
@property (assign, nonatomic) NSUInteger intervalMinutes;
@property (assign, nonatomic) NSUInteger intervalSeconds;
@property (assign, nonatomic) NSUInteger creditedDuration;
@property (assign, nonatomic) NSUInteger discontinueDuration;
@property (assign, nonatomic) NSUInteger retirementYear;
@property (assign, nonatomic) NSUInteger retirementMonth;
@property (assign, nonatomic) NSUInteger retirementDay;
@property (assign, nonatomic) CGFloat percent;
@property (assign, nonatomic) QualificationStatus qualificationStatus;
@property (assign, nonatomic) BOOL notificationSwitchState;
@property (assign, nonatomic) BOOL badgeSwitchState;

- (id)init;
- (id)initWithInfo:(CDInfo *)info;
- (CDInfo *)calculateIntervalWithTimer:(NSTimer *)timer;

@end
