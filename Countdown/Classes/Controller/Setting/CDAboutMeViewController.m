/*****************************************************************
 * Copyright (c) 2014 SongSheng. All rights reserved.
 *
 * Author: SongSheng
 * Create Date: 3/9/14
 * Usage:
 *
 * RevisionHistory
 * Date         Author         CRL        Description
 *
 *****************************************************************/

#import "CDAboutMeViewController.h"

@interface CDAboutMeViewController ()

@end

@implementation CDAboutMeViewController

+ (id)defaultController{
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.title = @"關於本程式";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
