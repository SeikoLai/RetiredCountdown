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

#import "FirstScreenViewController.h"
//Controller
#import "CDMasterViewController.h"
#import "FirstScreenPageViewController.h"
//Model
#import "CDInfo.h"
#import "CDCalculate.h"

@interface FirstScreenViewController () {
    
    __weak IBOutlet UILabel *_memoryDayLabel;
}

- (void)p_configurationWithPageViewController;

@end

@implementation FirstScreenViewController {
    UITapGestureRecognizer *tapGestureRecognizer;
    CDCalculate *calculate;
}


+ (id)defaultController{
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class])
                                          bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(tapAnywhereToDismissSelf:)];
        
        [self p_configurationWithPageViewController];
        [self.view addGestureRecognizer:tapGestureRecognizer];
        calculate = [[CDCalculate alloc] initWithTimestamp];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self dismissFirstScreen];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

- (void)p_configurationWithPageViewController{
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:
               UIPageViewControllerTransitionStyleScroll
                                              navigationOrientation:
               UIPageViewControllerNavigationOrientationHorizontal
                                                            options:nil];
    _pageVC.dataSource = self;
    [_pageVC.view setFrame:self.view.bounds];
    FirstScreenPageViewController *initialVC = [self viewControllerAtIndex:0];
    [_pageVC setViewControllers:@[initialVC]
                      direction:UIPageViewControllerNavigationDirectionForward
                       animated:YES
                     completion:nil];
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    [_pageVC didMoveToParentViewController:self];
}

- (void)dismissFirstScreen{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissSelf:)];
    NSOperationQueue *mainQuene = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissSelf:(UIGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIPageView DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [(FirstScreenPageViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [(FirstScreenPageViewController *)viewController index];
    index++;
    if (index == 3) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}

- (FirstScreenPageViewController *)viewControllerAtIndex:(NSUInteger)index{
    FirstScreenPageViewController *fspVC = [FirstScreenPageViewController defaultController];
    fspVC.index = index;
    return fspVC;
}

@end
