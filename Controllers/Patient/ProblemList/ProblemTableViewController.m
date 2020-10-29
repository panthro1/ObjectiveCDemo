//
//  ProblemTableViewController.m
//  doctor
//
//  Created by Thomas.Woodfin on 4/8/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "ProblemTableViewController.h"

@interface ProblemTableViewController ()

@end

@implementation ProblemTableViewController
@synthesize problemList;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return problemList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProblemCellId" forIndexPath:indexPath];
    cell.textLabel.text = problemList[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(delegate)
    {
        [delegate didSelectedProblemItem:problemList[indexPath.row]];
    }
}


@end
