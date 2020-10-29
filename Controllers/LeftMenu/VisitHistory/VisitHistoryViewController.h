//
//  VisitHistoryViewController.h
//  Griffin
//
//  Created by Thomas.Woodfin on 7/6/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitHistoryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView* visithistoryTableView;
    IBOutlet UILabel* visithistoryTitleLbl;
}

-(IBAction)backAction:(id)sender;

@end
