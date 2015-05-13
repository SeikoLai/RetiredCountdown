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

#import <Foundation/Foundation.h>

@class CDInfo;

@interface CDCalculate : NSObject

@property (nonatomic, strong) CDInfo *info;

- (id)initWithInfo:(CDInfo *)info;
- (id)initWithTimestamp;

// Data manipulate.
- (CDInfo *)readInfo;
- (void)writeInfo:(CDInfo *)info;

@end
