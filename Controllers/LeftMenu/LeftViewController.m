//
//  LeftViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 12/3/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "LeftViewController.h"
#import "AccountSettingsViewController.h"
#import "FinancialViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
//#import "NavigationUIViewController.h"
#import "VisitHistoryViewController.h"
#import <MessageUI/MessageUI.h>
#import "PaymentViewController.h"
#import "AKSSegmentedSliderControl.h"
#import "UIImage+FontAwesome.h"

#define WIDTH  282
#define HEIGHT 34
#define X_POS  20
#define Y_POS  242
#define RADIUS_POINT  10
#define SPACE_BETWEEN_POINTS  (IPAD_VERSION ? 40 : 24)
#define SPACE_BETWEEN_POINTS1  (IPAD_VERSION ? 20 : 9)
#define SLIDER_LINE_WIDTH     5
#define IPHONE_4_SUPPORT      88

@interface LeftViewController ()<UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, AKSSegmentedSliderControlDelegate> {
    int idxTime;
}
@property (weak, nonatomic) IBOutlet UIImageView *CardIcon;
@property (weak, nonatomic) IBOutlet UIButton *PaymentMenu;
@property (weak, nonatomic) IBOutlet UIImageView *SeparatePayment;



@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImage* user = [UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
    UIImage* share = [UIImage imageWithIcon:@"fa-share-alt" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
    UIImage* signout = [UIImage imageWithIcon:@"fa-sign-out" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
    
    UIImage* feescale = [UIImage imageWithIcon:@"fa-money" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(delegate.isPatient) {
        navigationGpsButton.hidden = YES;
        visitHistoryButton.hidden = YES;
        iconSignout.frame = iconVisitHistory.frame;
        signoutButton.frame = visitHistoryButton.frame;
        //left icon
        iconVisitHistory.hidden = YES;//iconNaviGPS.hidden =
        //seperator
        seperatorLineSignOut.hidden = YES;
        seperatorLine.hidden = YES;
         UIImage* payment = [UIImage imageWithIcon:@"fa-money" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
        
        _menuDataSource = @[@[payment, @"PAYMENT"], @[user, @"PROFILE"], @[share, @"SHARE"], @[signout, @"SIGN OUT"]];
    }
    else {
        _CardIcon.hidden = YES;
        _PaymentMenu.hidden = YES;
        _SeparatePayment.hidden = YES;
        CGRect frame = containerLeftMenu.frame;
        frame.origin.y = _PaymentMenu.frame.origin.y;
        containerLeftMenu.frame = frame;
        UIImage* history = [UIImage imageWithIcon:@"fa-history" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
        //UIImage* gps = [UIImage imageWithIcon:@"fa-map-marker" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
        UIImage* clock = [UIImage imageWithIcon:@"fa-clock-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
        
        _menuDataSource = @[@[user, @"PROFILE"], @[share, @"SHARE"], @[history, @"VISIT HISTORY"], /*@[gps, @"NAVIGATION GPS"],*/ @[clock, @"RESPONSE TIME"], @[feescale, @"FEE SCALE"] , @[signout, @"SIGN OUT"]];
    }
    [leftMenuTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITable datasource & delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id itemMenu = _menuDataSource[indexPath.row];
    UITableViewCell* cell;
    if ([itemMenu isKindOfClass:[NSArray class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMenuCellId"];
        UIButton* descriptionLbl = (UIButton*)[cell viewWithTag:2];
        [descriptionLbl setTitle:itemMenu[1] forState:UIControlStateNormal];
        UIImageView* iconImageView = (UIImageView*)[cell viewWithTag:1];
        iconImageView.image = itemMenu[0];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SliderCellId"];
        UIView* existedView = [cell viewWithTag:1];
        if (existedView) {
            [existedView removeFromSuperview];
        }
        existedView = [cell viewWithTag:2];
        if (existedView) {
            [existedView removeFromSuperview];
        }

        CGRect sliderConrolFrame = CGRectNull;
        UILabel* timeLbl = (UILabel*)[cell viewWithTag:3];
        if(!(IPAD_VERSION)) {
            sliderConrolFrame = CGRectMake(10,10,300,30);
        }
        else {
            sliderConrolFrame = CGRectMake(10,10,460,30);
        }
        
        AKSSegmentedSliderControl* sliderControl = [[AKSSegmentedSliderControl alloc] initWithFrame:sliderConrolFrame];
        [sliderControl setDelegate:self];
        NSString* title = itemMenu;
        PFUser* currentUser = [PFUser currentUser];
        if ([title isEqualToString:@"Slider"]) {
            sliderControl.tag = 1;
            NSString* responseTime = currentUser[@"ResponseTime"];
            if(responseTime && ![responseTime isEqualToString:@""]) {
                timeLbl.text = responseTime;
            } else {
                timeLbl.text = @"";
            }
            int index = 0;
            if ([responseTime isEqualToString:@"15 min"]) {
                index = 0;
            } else if ([responseTime isEqualToString:@"30 min"]) {
                index = 1;
            } else if ([responseTime isEqualToString:@"1 hour"]) {
                index = 2;
            } else if ([responseTime isEqualToString:@"1 hour 30 min"])  {
                index = 3;
            } else if ([responseTime isEqualToString:@"2 hour"]){
                index = 4;
            }
            [sliderControl moveToIndex:index];
            [sliderControl setSpaceBetweenPoints:SPACE_BETWEEN_POINTS];
            [sliderControl setRadiusPoint:RADIUS_POINT];
            [sliderControl setHeightLine:SLIDER_LINE_WIDTH];
            [cell.contentView addSubview:sliderControl];
        } else {
            sliderControl.tag = 2;
            NSString* feeScale = currentUser[@"FeeScale"];
            if(feeScale && ![feeScale isEqualToString:@""]) {
                timeLbl.text = feeScale;
            } else {
                timeLbl.text = @"";
            }
            idxTime = 0;
            if ([feeScale isEqualToString:@"$50"]) {
                idxTime = 0;
            } else if ([feeScale isEqualToString:@"$100"]) {
                idxTime = 1;
            } else if ([feeScale isEqualToString:@"$150"]) {
                idxTime = 2;
            } else if ([feeScale isEqualToString:@"$200"])  {
                idxTime = 3;
            } else if ([feeScale isEqualToString:@"$250"]){
                idxTime = 4;
            } else if ([feeScale isEqualToString:@"$300"]){
                idxTime = 5;
            } else if ([feeScale isEqualToString:@"$350"]){
                idxTime = 6;
            } else if ([feeScale isEqualToString:@"$400"]){
                idxTime = 7;
            } else if ([feeScale isEqualToString:@"$450"]){
                idxTime = 8;
            } else if ([feeScale isEqualToString:@"$500"]){
                idxTime = 9;
            }
            [sliderControl moveToIndex:idxTime];
            [sliderControl setNumberOfPoints:10];
            [sliderControl setSpaceBetweenPoints:SPACE_BETWEEN_POINTS1];
            [sliderControl setRadiusPoint:RADIUS_POINT];
            [sliderControl setHeightLine:SLIDER_LINE_WIDTH];
            [cell.contentView addSubview:sliderControl];
        }
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_menuDataSource[indexPath.row] isKindOfClass:[NSArray class]]) {
        NSString* itemMenuText = _menuDataSource[indexPath.row][1];
        if ([itemMenuText isEqualToString:@"PROFILE"]) {
            [self financialAction:nil];
        } else if ([itemMenuText isEqualToString:@"SHARE"]) {
            [self btn_Settings:nil];
        } else if ([itemMenuText isEqualToString:@"VISIT HISTORY"]) {
            [self visithistoryAction:nil];
        } else if ([itemMenuText isEqualToString:@"NAVIGATION GPS"]) {
            [self navigationGPS:nil];
        } else if ([itemMenuText isEqualToString:@"RESPONSE TIME"]) {
            UIImage* user = [UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            UIImage* share = [UIImage imageWithIcon:@"fa-share-alt" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            UIImage* signout = [UIImage imageWithIcon:@"fa-sign-out" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            UIImage* history = [UIImage imageWithIcon:@"fa-history" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            //UIImage* gps = [UIImage imageWithIcon:@"fa-map-marker" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            UIImage* clock = [UIImage imageWithIcon:@"fa-clock-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            
            UIImage* feescale = [UIImage imageWithIcon:@"fa-money" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            
            if (_menuDataSource.count == 7) {
                _menuDataSource = @[@[user, @"PROFILE"], @[share, @"SHARE"], @[history, @"VISIT HISTORY"], /*@[gps, @"NAVIGATION GPS"],*/ @[clock, @"RESPONSE TIME"], @[feescale, @"FEE SCALE"] ,@[signout, @"SIGN OUT"]];
            } else {
                _menuDataSource = @[@[user, @"PROFILE"], @[share, @"SHARE"], @[history, @"VISIT HISTORY"], /*@[gps, @"NAVIGATION GPS"],*/ @[clock, @"RESPONSE TIME"], @"Slider",@[feescale, @"FEE SCALE"], @[signout, @"SIGN OUT"]];
            }
            [leftMenuTableView reloadData];
        } else if ([itemMenuText isEqualToString:@"FEE SCALE"]) {
            UIImage* user = [UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            UIImage* share = [UIImage imageWithIcon:@"fa-share-alt" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            UIImage* signout = [UIImage imageWithIcon:@"fa-sign-out" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            UIImage* history = [UIImage imageWithIcon:@"fa-history" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            UIImage* clock = [UIImage imageWithIcon:@"fa-clock-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            
            UIImage* feescale = [UIImage imageWithIcon:@"fa-money" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:30];
            
            if (_menuDataSource.count == 7) {
                _menuDataSource = @[@[user, @"PROFILE"], @[share, @"SHARE"], @[history, @"VISIT HISTORY"], @[clock, @"RESPONSE TIME"], @[feescale, @"FEE SCALE"] ,@[signout, @"SIGN OUT"]];
               
            } else {
                _menuDataSource = @[@[user, @"PROFILE"], @[share, @"SHARE"], @[history, @"VISIT HISTORY"], @[clock, @"RESPONSE TIME"],@[feescale, @"FEE SCALE"], @"SliderFee", @[signout, @"SIGN OUT"]];
            }
             [leftMenuTableView reloadData];
        } else if ([itemMenuText isEqualToString:@"SIGN OUT"]) {
            [self logOut:nil];
        } else if ([itemMenuText isEqualToString:@"PAYMENT"]){
            [self paymentAction:nil];
        }
    }
}

#pragma -mark Response time delegate

- (void)timeSlider:(AKSSegmentedSliderControl *)timeSlider didSelectPointAtIndex:(int)index{
    UILabel* responseTimeLbl = (UILabel*)[leftMenuTableView viewWithTag:3];
    if (timeSlider.tag == 1) {
        if (index == 0) {
            responseTimeLbl.text = @"15 min";
        } else if (index == 1) {
            responseTimeLbl.text = @"30 min";
        } else if (index == 2) {
            responseTimeLbl.text = @"1 hour";
        } else if (index == 3) {
            responseTimeLbl.text = @"1 hour 30 min";
        } else {
            responseTimeLbl.text = @"2 hour";
        }
        [PFUser currentUser][@"ResponseTime"] = responseTimeLbl.text;
        [[PFUser currentUser] saveInBackground];
    } else {
        if (index == 0) {
            responseTimeLbl.text = @"$50";
        } else if (index == 1) {
            responseTimeLbl.text = @"$100";
        } else if (index == 2) {
            responseTimeLbl.text = @"$150";
        } else if (index == 3) {
            responseTimeLbl.text = @"$200";
        } else if (index == 4) {
            responseTimeLbl.text = @"$250";
        } else if (index == 5) {
            responseTimeLbl.text = @"$300";
        } else if (index == 6) {
            responseTimeLbl.text = @"$350";
        } else if (index == 7) {
            responseTimeLbl.text = @"$400";
        } else if (index == 8) {
            responseTimeLbl.text = @"$450";
        } else if (index == 9) {
            responseTimeLbl.text = @"$500";
        }
        [PFUser currentUser][@"FeeScale"] = responseTimeLbl.text;
        [[PFUser currentUser] saveInBackground];
    }
    
}

- (IBAction)visithistoryAction:(id)sender
{
    VisitHistoryViewController* visithistory = [self.storyboard instantiateViewControllerWithIdentifier:@"VisitHistoryViewControlleriPhone"];
    [self.navigationController pushViewController:visithistory animated:YES];
}

- (IBAction)btn_Home:(id)sender {
}

- (IBAction)btn_Profile:(id)sender {
    AccountSettingsViewController* accountSettingController = [self.storyboard instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"AccountSettingsViewController" : @"AccountSettingsViewControlleriPhone")];
    [self.navigationController pushViewController:accountSettingController animated:YES];
    
}

- (IBAction)paymentAction:(id)sender
{
    PaymentViewController* paymentCL = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    [self.navigationController pushViewController:paymentCL animated:YES];
}

-(IBAction)navigationGPS:(id)sender
{
    //NavigationUIViewController* gpsNavigation = [[NavigationUIViewController alloc] init];
    //[self.navigationController pushViewController:gpsNavigation animated:YES];
}

-(IBAction)financialAction:(id)sender {
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    FinancialViewController* financialController = [self.storyboard instantiateViewControllerWithIdentifier:(delegate.isPatient ? (IPAD_VERSION ? @"clientFinancialViewiPad" : @"clientFinancialViewiPhone") : (IPAD_VERSION ? @"clientFinancialViewDociPad" : @"clientFinancialViewDoc"))];
    [self.navigationController pushViewController:financialController animated:YES];
}

- (IBAction)btn_Promotions:(id)sender {
}

- (IBAction)btn_Messages:(id)sender {
}

- (IBAction)btn_Settings:(id)sender
{
    UIActionSheet* menuOptionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"SMS text message",@"Email", nil];
    [menuOptionsActionSheet showInView:self.masterDetailViewController.view];
}

- (IBAction)logOut:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logOut" object:nil];
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
 * Process action index when press on Menu options
 */
-(void)processSelectMenuOption:(NSInteger)index
{
    switch (index) {
        case 0:
            //Facebook
        {
            //  Create an instance of the Tweet Sheet
            SLComposeViewController *fbSheet = [SLComposeViewController
                                                composeViewControllerForServiceType:
                                                SLServiceTypeFacebook];
            
            // Sets the completion handler.  Note that we don't know which thread the
            // block will be called on, so we need to ensure that any required UI
            // updates occur on the main queue
            fbSheet.completionHandler = ^(SLComposeViewControllerResult result) {
                switch(result) {
                        //  This means the user cancelled without sending the FB post
                    case SLComposeViewControllerResultCancelled:
                        break;
                        //  This means the user hit 'Send'
                    case SLComposeViewControllerResultDone:
                        break;
                }
            };
            //  Set the initial body of the FB post
            [fbSheet setInitialText:@"Download Swurvin and enjoy it on your iPhone, iPad, and iPod touch - https://itunes.apple.com/us/app/doctor-Roadside-doctor/id976317328?mt=8"];
            //  Presents the Tweet Sheet to the user
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:fbSheet animated:NO completion:^{
                    NSLog(@"Tweet sheet has been presented.");
                }];
            });
        }
            break;
        case 1:
            //Twitter
        {
            //  Create an instance of the Tweet Sheet
            SLComposeViewController *fbSheet = [SLComposeViewController
                                                composeViewControllerForServiceType:
                                                SLServiceTypeTwitter];
            
            // Sets the completion handler.  Note that we don't know which thread the
            // block will be called on, so we need to ensure that any required UI
            // updates occur on the main queue
            fbSheet.completionHandler = ^(SLComposeViewControllerResult result) {
                switch(result) {
                        //  This means the user cancelled without sending the FB post
                    case SLComposeViewControllerResultCancelled:
                        break;
                        //  This means the user hit 'Send'
                    case SLComposeViewControllerResultDone:
                        break;
                }
            };
            //  Set the initial body of the FB post
            [fbSheet setInitialText:@"Download Doctor  and enjoy it on your iPhone, iPad, and iPod touch - https://itunes.apple.com/us/app/doctor-Roadside-doctor/id976317328?mt=8"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //  Presents the Tweet Sheet to the user
                [self presentViewController:fbSheet animated:NO completion:^{
                    NSLog(@"Tweet sheet has been presented.");
                }];
            });
        }
            break;
        case 2:
            //SMS text message
        {
            if([MFMessageComposeViewController canSendText])
            {
                MFMessageComposeViewController* message = [[MFMessageComposeViewController alloc] init];
                message.messageComposeDelegate = self;
                message.body = @"Download Doctor and book a doctor on your iPhone, iPad, and iPod touch -https://itunes.apple.com/us/app/doctor-Roadside-doctor/id976317328?mt=8";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:message animated:YES completion:nil];
                });
            }
            else
            {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We are sorry but iPads do not support SMS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
            }
        }
            break;
        case 3:
            //Email
        {
            if([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                picker.mailComposeDelegate = self;
                [picker setSubject:@"Swurvin"];
                NSString* emailBody = @"Download Swurvin and book a doctor on your iPhone, iPad, and iPod touch - https://itunes.apple.com/us/app/doctor-Roadside-doctor/id976317328?mt=8";
                [picker setMessageBody:emailBody isHTML:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:picker animated:YES completion:nil];
                });
            }
            else
            {
                UIAlertView* noAccount = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please log in to your Mail via Settings-> Mail, Contacts, Calendars -> Add Account.”" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [noAccount show];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma -mark ActionSheet Delegate Impl

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self processSelectMenuOption:buttonIndex];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



@end
