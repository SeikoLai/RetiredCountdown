/*****************************************************************
 * Copyright (c) 2014 SongSheng. All rights reserved.
 *
 * Author: SongSheng
 * Create Date: 2/14/14
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "CDCalculate.h"
//Model
#import "CDInfo.h"

@interface CDCalculate ()

- (NSString *)p_path;
- (NSUInteger)p_integerFromQualificationStatus:(QualificationStatus)qulificationStatus;

@end

@implementation CDCalculate

- (id)init{
    if (self = [super init]) {
    }
    return self;
}

- (id)initWithTimestamp{
    if (self) {
        _info = [[CDInfo alloc] initWithInfo:[self readInfo]];
    }
    return self;
}

- (id)initWithInfo:(CDInfo *)info{
    if (self = [super init]) {
        _info = [[CDInfo alloc] initWithInfo:info];
    }
    return self;
}

#pragma mark - Get path

- (NSString *)p_path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    NSString *path = [documentDirectory stringByAppendingString:@"/Countdown.plist"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *newFilePath = [documentDirectory stringByAppendingString:@"/Countdown.plist"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Countdown" ofType:@"plist"];
        NSArray *data = [NSArray arrayWithContentsOfFile:path];
        [data writeToFile:newFilePath atomically:YES];
    }
    return path;
}

#pragma mark - Read data

- (CDInfo *)readInfo{
    @autoreleasepool {
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self p_path]];
        _info = [[CDInfo alloc] initWithInfo:(_info) ? _info : nil];
        _info.enlistmentDate = dataDict[LSSEnlistmentDate];
        _info.intervalDays = [dataDict[LSSIntervalDays] integerValue];
        _info.intervalHours = [dataDict[LSSIntervalHours] integerValue];
        _info.intervalMinutes = [dataDict[LSSIntervalMinutes] integerValue];
        _info.intervalSeconds = [dataDict[LSSIntervalSeconds] integerValue];
        _info.creditedDuration = [dataDict[LSSCreditedDuration] integerValue];
        _info.discontinueDuration = [dataDict[LSSDiscontinueDuration] integerValue];
        _info.retirementDay = [dataDict[LSSRetirementDay] integerValue];
        _info.retirementMonth = [dataDict[LSSRetirementMonth] integerValue];
        _info.retirementYear = [dataDict[LSSRetirementYear] integerValue];
        _info.percent = [dataDict[LSSPercent] floatValue];
        _info.qualificationStatus = [dataDict[LSSQualificationStatus] integerValue];
        _info.notificationSwitchState = [dataDict[LSSNotificationSwitchState] boolValue];
        _info.badgeSwitchState = [dataDict[LSSBadgeSwitchState] boolValue];
        return _info;
    }
}

#pragma mark - Write data

- (void)writeInfo:(CDInfo *)info{
    @autoreleasepool {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        _info = [[CDInfo alloc] initWithInfo:info];
        mutableDict[LSSEnlistmentDate] = info.enlistmentDate;
        mutableDict[LSSIntervalDays] = [NSNumber numberWithUnsignedInteger:_info.intervalDays];
        mutableDict[LSSIntervalHours] = [NSNumber numberWithUnsignedInteger:_info.intervalHours];
        mutableDict[LSSIntervalMinutes] = [NSNumber numberWithUnsignedInteger:_info.intervalMinutes];
        mutableDict[LSSIntervalSeconds] = [NSNumber numberWithUnsignedInteger:_info.intervalSeconds];
        mutableDict[LSSCreditedDuration] = [NSNumber numberWithUnsignedInteger:_info.creditedDuration];
        mutableDict[LSSDiscontinueDuration] = [NSNumber numberWithUnsignedInteger:_info.discontinueDuration];
        mutableDict[LSSRetirementDay] = [NSNumber numberWithUnsignedInteger:_info.retirementDay];
        mutableDict[LSSRetirementMonth] = [NSNumber numberWithUnsignedInteger:_info.retirementMonth];
        mutableDict[LSSRetirementYear] = [NSNumber numberWithUnsignedInteger:_info.retirementYear];
        mutableDict[LSSPercent] = [NSNumber numberWithFloat:_info.percent];
        mutableDict[LSSQualificationStatus] = [NSNumber numberWithUnsignedInteger:[self p_integerFromQualificationStatus:_info.qualificationStatus]];
        mutableDict[LSSNotificationSwitchState] = [NSNumber numberWithUnsignedInteger:_info.notificationSwitchState];
        mutableDict[LSSBadgeSwitchState] = [NSNumber numberWithUnsignedInteger:_info.badgeSwitchState];

        NSString *message = ([mutableDict writeToFile:[self p_path] atomically:YES]) ? @"Wrote data successful" : @"Wrote data fail";
        NSLog(@"%@", message);
    }
}

- (NSUInteger)p_integerFromQualificationStatus:(QualificationStatus)qualificationStatus{
    int status = 0;
    switch (qualificationStatus) {
        case QualificationStatusOfStanding:
            status = 0;
            break;
        case QualificationStatusOfSubstituteStatus:
            status = 1;
            break;
        case QualificationStatusOfFamilyFactorsStatus:
            status = 2;
            break;
    }
    return status;
}

@end
