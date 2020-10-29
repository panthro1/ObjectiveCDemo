//
//  DoctorNotificationListUI.m
//  doctor
//
//  Created by Thomas.Woodfin on 5/28/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "DoctorNotificationListUI.h"
#import "MBProgressHUD.h"
#import "DoctorNotificationCell.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface DoctorNotificationListUI ()
{
    NSTimer* timer;
}
@end

@implementation DoctorNotificationListUI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(skipAction:)];
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:YES];
    self.title = @"Patient request";
    //timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(refreshDoctorNotificatioList) userInfo:nil repeats:YES];//30s
}


-(IBAction)skipAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //self.navigationController.navigationBar.hidden = YES;
    [super viewWillDisappear:animated];
    [timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _doctorNotification.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellnotificationId" forIndexPath:indexPath];
    PFObject* object = _doctorNotification[indexPath.row];
    [cell setcontentDisplay:object];
    cell.Controller = self;
    return cell;
}

-(void)refreshDoctorNotificatioList
{
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Doctor" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"requestStatus" equalTo:@"Pending"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if(objects.count > 0)
            {
                if(objects.count != _doctorNotification.count)
                {
                    _doctorNotification = objects;
                    [self.tableView reloadData];
                }
            }
            
        }
    }];
    
}

-(void)reloadData
{
    [self.tableView reloadData];
}

-(void)showWaiting
{
    [SVProgressHUD show];
}

-(void)dismissWaiting
{
    [SVProgressHUD dismiss];
}


@end
