//
//  ConfirmationMessageViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 12/7/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "ConfirmationMessageViewController.h"
#import "MasterDetailViewController.h"

@interface ConfirmationMessageViewController ()<UIAlertViewDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation ConfirmationMessageViewController
@synthesize doctor;

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btn_Call:(id)sender
{

    NSString* phonenumber = self.doctor[@"PhoneNumber"];
    phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phonenumber]];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We are sorry but iPads do not support dial or SMS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
    }

}

- (IBAction)btn_Text:(id)sender
{
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We are sorry but iPads do not support dial or SMS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    NSString* phonenumber = self.doctor[@"PhoneNumber"];
    phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSArray *recipents = @[phonenumber];
    NSString *message = @"Thank you for using Swurvin.";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        UITextField* textField = [alertView textFieldAtIndex:0];
        if([textField hasText])
        {
            NSString* phonenumber = self.doctor[@"PhoneNumber"];
            phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@")" withString:@""];
            phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            phonenumber = [phonenumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phonenumber]];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            else
            {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We are sorry but iPads do not support dial or SMS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
            }
        }
    }
}

- (IBAction)btn_Close:(id)sender {
    
    MasterDetailViewController* masterDetail = [self.storyboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
    [self.navigationController pushViewController:masterDetail animated:YES];
}
@end
