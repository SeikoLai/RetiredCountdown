/*****************************************************************
 * Copyright (c) 2013 Newegg. All rights reserved.
 *
 * Author: Sam.S.Lai
 * Create Date: 12/11/13
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import <UIKit/UIKit.h>

@interface FirstScreenViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageVC;
+ (id)defaultController;

@end
