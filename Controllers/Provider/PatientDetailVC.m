//
//  PatientDetailVC.m
//  doctor
//
//  Created by Thomas Woodfin on 2/1/16.
//  Copyright © 2016 Thomas. All rights reserved.
//

#import "PatientDetailVC.h"

@interface PatientDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *SymptomsLbl;
@property (weak, nonatomic) IBOutlet UILabel *AdditionLbl;
@property (weak, nonatomic) IBOutlet UILabel *AgeLbl;


@end

@implementation PatientDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark Setter

- (void) setPaitientObject:(PFObject *)PaitientObject {
    _PaitientObject = PaitientObject;
    _AgeLbl.text = _PaitientObject[@"Age"];
    _AdditionLbl.text = _PaitientObject[@"ProblemDetail"];
    _SymptomsLbl.text = _PaitientObject[@"Problem"];
}

#pragma -mark Actions

- (IBAction)closedPopup:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
