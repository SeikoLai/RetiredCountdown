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

#import "CDMasterViewController.h"
//Controller
#import "CDDetailViewController.h"
#import "FirstScreenViewController.h"
//View
#import "CDBasicCell.h"
#import "CDRightDetailCell.h"
#import "CDBasicDetailCell.h"
#import "CDDatePickerCell.h"
//Model
#import "CDInfo.h"
#import "CDCalculate.h"

typedef NS_ENUM (NSInteger, SectionHeader) {
    SectionHeaderOfQualification    = 0,
    SectionHeaderOfEnlistedTime     = 1,
    SectionHeaderOfCalculate        = 2
};

typedef NS_ENUM (NSInteger, Qualification) {
    QualificationOfStanding         = 0,
    QualificationOfSubstitute       = 1,
    QualificationOfFamilyFactors    = 2
};

@interface CDMasterViewController () <UITableViewDelegate, UITableViewDataSource, CDDatePickerCellDelegate>

- (IBAction)calculateButtonPressed:(id)sender;

@end

@implementation CDMasterViewController {
    NSDate                      *_selectedDate;
    NSUInteger                  _selectedIndex;
    CDBasicDetailCell           *basicDetailCell;
    CDDatePickerCell            *datePickerCell;
    CDInfo                      *_info;
    CDCalculate                 *_calculationManager;
    BOOL                        _success;
    __weak IBOutlet UITableView *_masterTableView;
}

+ (id)defaultController{
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

#pragma mark - Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"退伍倒數計算器";
        _selectedIndex = 0;
        _calculationManager = [[CDCalculate alloc] initWithTimestamp];
        _info = _calculationManager.info;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self firstViewController];
    [self registerCell];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self slidePickerViewAnimated:animated];
    [self staticDatePickerViewAnimated:animated];
    [self basicDetailCellTitleAnimated:animated];
    [self basicDetailCellButtonAnimated:animated];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section == 1) ? 216.0f : 48.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return 48.0f;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    CDBasicCell         *basicCell;
    UIView              *viewForHeader = [[UIView alloc] initWithFrame:[basicCell frame]];
    switch (section) {
        case SectionHeaderOfQualification:
            basicCell = [tableView dequeueReusableCellWithIdentifier:[CDBasicCell stringFromSelf]];
            [basicCell setTitleText:@"入伍資格"];
            [viewForHeader addSubview:basicCell];
            break;
        case SectionHeaderOfEnlistedTime:
            basicDetailCell = [tableView dequeueReusableCellWithIdentifier:[CDBasicDetailCell stringFromSelf]];
            [basicDetailCell setTitleText:@"入伍日期"];
            [basicDetailCell addButtonAction:@selector(pressed:)
                                   forTarget:self];
            [viewForHeader addSubview:basicDetailCell];
            break;
    }
    return viewForHeader;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    switch (indexPath.section) {
        case SectionHeaderOfQualification:
            _info.qualificationStatus = (indexPath.row) ? indexPath.row : 0;
            [self reloadRows];
            break;
        case SectionHeaderOfEnlistedTime:
            break;
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return (section == SectionHeaderOfQualification) ? 3 : 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell     *cell;
    CDRightDetailCell   *rightDetailCell = [tableView dequeueReusableCellWithIdentifier:[CDRightDetailCell stringFromSelf]];
    
    switch (indexPath.section) {
        case SectionHeaderOfQualification:
            switch (indexPath.row) {
                case QualificationOfStanding:
                    [rightDetailCell setTitleText:@"常備役體位"
                                  andSubtitleText:@"服役時間：380天"];
                    cell = rightDetailCell;
                    break;
                case QualificationOfSubstitute:
                    [rightDetailCell setTitleText:@"替代役體位"
                                  andSubtitleText:@"服役時間：365天"];
                    cell = rightDetailCell;
                    break;
                case SectionHeaderOfCalculate:
                    [rightDetailCell setTitleText:@"家庭因素"
                                  andSubtitleText:@"服役時間：365天"];
                    cell = rightDetailCell;
                    break;
            }
            if (indexPath.row == ((_info.qualificationStatus) ? _info.qualificationStatus : _selectedIndex)) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case SectionHeaderOfEnlistedTime:
            datePickerCell = [tableView dequeueReusableCellWithIdentifier:[CDDatePickerCell stringFromSelf]];
            [datePickerCell setDelegate:self];
            [datePickerCell addPickerTarget:self andAction:@selector(selectedDate:)];
            [datePickerCell.staticDatePickerView setDate:_info.enlistmentDate ? _info.enlistmentDate : [NSDate date]];
            [datePickerCell.picker selectRow:_info.creditedDuration ? _info.creditedDuration : 0
                                 inComponent:0
                                    animated:NO];
            [datePickerCell.picker selectRow:_info.discontinueDuration ? _info.discontinueDuration : 0
                                 inComponent:1
                                    animated:NO];
            cell = datePickerCell;
            break;
    }
    return cell;
}

#pragma mark - Private Tasks

- (void)reloadRows{
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:QualificationOfStanding
                                               inSection:SectionHeaderOfQualification],
                            [NSIndexPath indexPathForRow:QualificationOfSubstitute
                                               inSection:SectionHeaderOfQualification],
                            [NSIndexPath indexPathForRow:QualificationOfFamilyFactors
                                               inSection:SectionHeaderOfQualification]];
    [_masterTableView beginUpdates];
    [_masterTableView reloadRowsAtIndexPaths:indexPaths
                            withRowAnimation:UITableViewRowAnimationNone];
    [_masterTableView endUpdates];
}

- (void)slidePickerViewAnimated:(BOOL)animated{
    CGFloat offsetX = (animated == YES) ? 320.0f : 0.0f;
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [datePickerCell.slidePickerView setFrame:CGRectMake(offsetX,
                                                                             CGRectGetMinY(datePickerCell.slidePickerView.bounds),
                                                                             CGRectGetWidth(datePickerCell.slidePickerView.frame),
                                                                             CGRectGetHeight(datePickerCell.slidePickerView.frame))];
                     }
                     completion:nil];
}

- (void)staticDatePickerViewAnimated:(BOOL)animated{
    CGFloat staticPickerAlpha = (animated == YES) ? 1.0f : 0.0f;
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         datePickerCell.staticDatePickerView.alpha = staticPickerAlpha;
                     }
                     completion:nil];
}

- (void)basicDetailCellTitleAnimated:(BOOL)animated{
    basicDetailCell.titleLabel.text = (animated == YES) ? @"入伍日期" : @"折抵天數";;
}

- (void)basicDetailCellButtonAnimated:(BOOL)animated{
    basicDetailCell.detailButton.titleLabel.text = (animated == YES) ? @"折抵" : @"入伍";
    basicDetailCell.detailButton.selected = (animated == YES) ? NO : YES;
}

- (void)pressed:(UIButton *)sender{
    if ([sender isSelected] == YES) {
        [sender setSelected:NO];
        [self basicDetailCellTitleAnimated:YES];
        [self slidePickerViewAnimated:YES];
        [self staticDatePickerViewAnimated:YES];
    } else {
        [sender setSelected:YES];
        [self basicDetailCellTitleAnimated:NO];
        [self slidePickerViewAnimated:NO];
        [self staticDatePickerViewAnimated:NO];
    }
}

- (void)registerCell{
    NSArray *cellArray = @[[CDBasicCell class],
                           [CDRightDetailCell class],
                           [CDBasicDetailCell class],
                           [CDDatePickerCell class]];
    for (Class class in cellArray) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([class class])
                                    bundle:nil];
        [_masterTableView registerNib:nib
               forCellReuseIdentifier:NSStringFromClass([class class])];
    }
}

- (void)selectedDate:(NSDate *)date{
    _info.enlistmentDate = datePickerCell.staticDatePickerView.date;
}

- (void)creditedInfo:(UIPickerView *)sender{
    _info.creditedDuration = [sender selectedRowInComponent:0];
    _info.discontinueDuration = [sender selectedRowInComponent:1];
}

- (IBAction)calculateButtonPressed:(id)sender{
    [_calculationManager writeInfo:_info];
    CDDetailViewController *dvc = [CDDetailViewController defaultController];
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - Push First View Controller

- (void)firstViewController{
    /* Present next run loop. Prevents "unbalanced VC display" warnings. */
    dispatch_async(dispatch_get_main_queue(), ^(void){
        FirstScreenViewController *fsvc = [FirstScreenViewController defaultController];
        [self presentViewController:fsvc animated:YES completion:nil];
    });
}

@end
