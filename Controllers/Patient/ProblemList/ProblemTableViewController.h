//
//  ProblemTableViewController.h
//  doctor
//
//  Created by Thomas.Woodfin on 4/8/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProblemListDelegate

@optional
-(void)didSelectedProblemItem:(NSString*)problemItem;

@end

@interface ProblemTableViewController : UITableViewController

/*
 * List all problems
 */
@property(nonatomic, strong) NSMutableArray* problemList;
/*
 * call back to parent when select problem from list
 */
@property(nonatomic, assign) id<ProblemListDelegate> delegate;

@end
