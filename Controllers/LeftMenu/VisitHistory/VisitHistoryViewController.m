//
//  VisitHistoryViewController.m
//  Griffin
//
//  Created by Thomas.Woodfin on 7/6/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "VisitHistoryViewController.h"
#import "DateCollectionViewCell.h"
#import "ContentCollectionViewCell.h"
#import "CustomCollectionViewLayout.h"
#import "MBProgressHUD.h"
#import "PatientDetailVC.h"

@interface VisitHistoryViewController ()
{
    NSMutableArray* _arrayVisits;
}
@end

@implementation VisitHistoryViewController

- (void)viewDidLoad {
    visithistoryTitleLbl.text = [NSString stringWithFormat:@"%@'s Visit History", [PFUser currentUser][@"FirstName"]];
    visithistoryTableView.tableFooterView = [UIView new];
    [financialButton setTitle:nil forState:UIControlStateNormal];
    [financialButton setImage:[UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30] forState:UIControlStateNormal];
    [super viewDidLoad];
    [self showWaiting];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Doctor" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"Patient"];
    [postQuery whereKey:@"PatientVisited" equalTo:[NSNumber numberWithBool:YES]];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self dismissWaiting];
        if(!_arrayVisits)
        {
            _arrayVisits = [[NSMutableArray alloc] init];
        }
        [_arrayVisits removeAllObjects];
        if(objects){
            [_arrayVisits  addObjectsFromArray:objects];
        } else {
            [_arrayVisits addObject:@"Nothing to display"];
        }
        [visithistoryTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -Mark Impl UICollectionViewDelegate & datasource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 134;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayVisits.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = _arrayVisits[indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        UITableViewCell* nothingCell = [tableView dequeueReusableCellWithIdentifier:@"nothingCell"];
        return nothingCell;
    } else {
        //Content
        PFObject* pobject = object;
        PFUser* user = pobject[@"Patient"];
        UITableViewCell* contentCell = [tableView dequeueReusableCellWithIdentifier:@"VisitHistoryCell"];
        UILabel* dateLbl = (UILabel*)[contentCell viewWithTag:1];
        UILabel* nameLbl = (UILabel*)[contentCell viewWithTag:2];
        UILabel* statusLbl = (UILabel*)[contentCell viewWithTag:3];
        UILabel* emailLbl = (UILabel*)[contentCell viewWithTag:4];
        UIButton* patientDetailButton = (UIButton*)[contentCell viewWithTag:8];
        patientDetailButton.tag = indexPath.row;
        [patientDetailButton addTarget:self action:@selector(patientDetail:) forControlEvents:UIControlEventTouchUpInside];
        NSDate* startDate = pobject[@"RequestDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"MMMM dd"];
        NSString* startStr = [formatter stringFromDate:startDate];
        dateLbl.text = [NSString stringWithFormat:@"%@%@", startStr, [self suffixForDayInDate:startDate]];
        nameLbl.text = [NSString stringWithFormat:@"%@ %@", user[@"FirstName"], user[@"LasttName"]];
        statusLbl.text = [NSString stringWithFormat:@"Status: %@", @"Completed"];
        emailLbl.text = user.email;
        return contentCell;
    }
}

- (IBAction)patientDetail:(UIButton*)sender {
    id object =  _arrayVisits[sender.tag];
    if (![object isKindOfClass:[NSString class]]) {
        PatientDetailVC* patientVC = [[PatientDetailVC alloc] init];
        patientVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        patientVC.modalPresentationStyle= UIModalPresentationCustom;
        patientVC.PaitientObject = object;
        [patientVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:patientVC animated:TRUE completion:nil];
    }
    
}

-(IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper method

- (NSString *)suffixForDayInDate:(NSDate *)date{
    
    NSInteger day = [[[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitHour fromDate:date] day];
    if (day >= 11 && day <= 13) {
        return @"th";
    } else if (day % 10 == 1) {
        return @"st";
    } else if (day % 10 == 2) {
        return @"nd";
    } else if (day % 10 == 3) {
        return @"rd";
    } else {
        return @"th";
    }
}

@end
