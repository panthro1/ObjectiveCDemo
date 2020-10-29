//
//  PatientRequestViewController.m
//  doctor
//
//  Created by Muhammad Imran on 12/12/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "PatientRequestViewController.h"
#import "PatientRequestCell.h"
#import <parse/parse.h>
#import "JPSThumbnailAnnotation.h"
#import "DoctorNotificationListUI.h"
#import "AFHTTPRequestOperationManager.h"
#define span 40000
@interface PatientRequestViewController ()
{
    NSTimer* _requestDoctorTimer;
    NSTimer* _refreshDoctorTimer;
}
@end

@implementation PatientRequestViewController

-(void)tapDismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)getDoctorNotification
{
    PFUser* user = [PFUser currentUser];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Doctor" equalTo:user];
    [postQuery whereKey:@"requestStatus" equalTo:@"Pending"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self dismissWaiting];
        if (!error) {
            
            [self checkNotification:objects];
            
        }
    }];
    [_tableView reloadData];
}

-(void)checkNotification:(NSArray*)objects
{
    BOOL flag = FALSE;
    for (UIViewController* viewCL in self.navigationController.viewControllers) {
        if([viewCL isKindOfClass:[DoctorNotificationListUI class]])
        {
            flag = TRUE;
            ((DoctorNotificationListUI*)viewCL).doctorNotification = objects;
            [((DoctorNotificationListUI*)viewCL) reloadData];
            break;
        }
    }
    if(!flag)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(objects.count > 0)
            {
                UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                DoctorNotificationListUI* doctorNotificationCL = [story instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"DoctorNotificationListUIiPad" : @"DoctorNotificationListUIiPhone")];
                doctorNotificationCL.doctorNotification = objects;
                [self.navigationController pushViewController:doctorNotificationCL animated:YES];
            }
            
        });
        
    }
}

- (void)viewDidLoad {
    _tableView.estimatedRowHeight = 44.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [super viewDidLoad];
    [menuButton setImage:MENU_ICO forState:UIControlStateNormal];
    //Store user to installation
    PFInstallation* installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:@"logOut" object:nil];
    UITapGestureRecognizer* tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
    [self.view addGestureRecognizer:tapView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 5;
    _mapView.layer.masksToBounds = YES;
    _mapView.layer.cornerRadius = 5;
    _tableView.hidden = TRUE;
    PFUser* currentUser = [PFUser currentUser];
    BOOL isHideDoctor = [currentUser[@"isHideMap"] boolValue];
    _doctorMapLocatorSwitch.on = !isHideDoctor;
    NSString* feeScale = [PFUser currentUser][@"FeeScale"];
    NSString* responseTime = [PFUser currentUser][@"ResponseTime"];
    if (!feeScale || [feeScale isEqualToString:@""] || !responseTime || [responseTime isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please setup a fee scale or response time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.view layoutIfNeeded];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
    self.navigationController.navigationBar.hidden = YES;
    if(!_requestDoctorTimer)
    {
        _requestDoctorTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getDoctorNotification) userInfo:nil repeats:YES];
    }
    if(_refreshDoctorTimer) {
        [_refreshDoctorTimer invalidate];
        _refreshDoctorTimer = nil;
    }
    _refreshDoctorTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshPatient) userInfo:nil repeats:YES];
    [self.mapView setShowsUserLocation:YES];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[_requestDoctorTimer invalidate];
    //_requestDoctorTimer = nil;
}

-(void)reloadData
{
    [self showWaiting];
    NSArray* requestStatus = @[@"Accepted", @"Paid"];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Doctor" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"Patient"];
    [postQuery whereKey:@"requestStatus" containedIn:requestStatus];
    [postQuery whereKey:@"PatientVisited" notEqualTo:[NSNumber numberWithBool:YES]];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self dismissWaiting];
        if (!error) {
            
            _requests = objects;
            [_tableView reloadData];
            if (self.requests.count > 0) {
                //Adjust layout
                _tableView.hidden = FALSE;
                CGRect frame = _mapView.frame;
                frame.origin.y = _tableView.frame.origin.y + MIN(312 * _requests.count, _tableView.frame.size.height);
                frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y - 20;
                _mapView.frame = frame;
            }
            else
            {
                //Adjust layout
                _tableView.hidden = TRUE;
                CGRect frame = _mapView.frame;
                frame.origin.y = (IPAD_VERSION ? 179 : 137);
                frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y - 10;
                _mapView.frame = frame;
            }
            
        }
    }];
}

- (void) refreshPatient {
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        PFUser* user = [PFUser currentUser];
        if (geoPoint && error == nil) {
            user [@"location"] = geoPoint;
            [user saveInBackground];
            
        }
    }];
    NSArray* requestStatus = @[@"Accepted", @"Paid"];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"PatientRequest"];
    [postQuery whereKey:@"Doctor" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"Patient"];
    [postQuery whereKey:@"requestStatus" containedIn:requestStatus];
    [postQuery whereKey:@"PatientVisited" notEqualTo:[NSNumber numberWithBool:YES]];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self dismissWaiting];
        if (!error) {
            
            if (_requests.count != objects.count) {
                _requests = objects;
                [_tableView reloadData];
                if (self.requests.count > 0) {
                    //Adjust layout
                    _tableView.hidden = FALSE;
                    CGRect frame = _mapView.frame;
                    frame.origin.y = _tableView.frame.origin.y + MIN(312 * _requests.count, _tableView.frame.size.height);
                    frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y - 20;
                    _mapView.frame = frame;
                }
                else
                {
                    //Adjust layout
                    _tableView.hidden = TRUE;
                    CGRect frame = _mapView.frame;
                    frame.origin.y = (IPAD_VERSION ? 179 : 137);
                    frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y - 10;
                    _mapView.frame = frame;
                }
            }
            
            
        }
    }];
}

-(void)logOut
{
    [_requestDoctorTimer invalidate];
    [_refreshDoctorTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logOut" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D loc = [userLocation.location coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000.0f, 1000.0f);
    [aMapView setRegion:region animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.requests count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 312;
//}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier = @"PatientRequestCell";
     PatientRequestCell *cell = (PatientRequestCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     
     if (cell == nil) {

         NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PatientRequestCelliPhone" owner:nil options:nil];
         for(id currentObject in topLevelObjects) {
             if ([currentObject isKindOfClass:[UITableViewCell class] ]){
                 cell = (PatientRequestCell *)currentObject;
                 break;
             }
         }
     }

     UIButton *showLocationBtn = (UIButton*)[cell viewWithTag:10.0];
     UIButton *patientVisitedBtn = (UIButton*)[cell viewWithTag:11.0];
     
     cell.tag = indexPath.row;
     
     [showLocationBtn addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
     showLocationBtn.tag = indexPath.row;
     [patientVisitedBtn addTarget:self action:@selector(patientVisited:) forControlEvents:UIControlEventTouchUpInside];
     patientVisitedBtn.tag = indexPath.row;
    patientVisitedBtn.userInteractionEnabled = TRUE;
     
     PFObject *request = [self.requests objectAtIndex:indexPath.row];
     NSLog(@"%@",request);
     [cell setUpCellData:request];
     return cell;
 }

- (IBAction)showLocation:(UIButton*)sender
{
    PFObject *request = [self.requests objectAtIndex:sender.tag];
   [self setAnnotions:request];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Pin shown on user location on map." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)patientVisited:(id)sender
{
    UIButton *cellForButton = (UIButton*)sender;
    PFObject *request = [self.requests objectAtIndex:cellForButton.tag];
    request[@"PatientVisited"] = [NSNumber numberWithBool:YES];
    request[@"requestStatus"] = @"FullPaid";
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFObject* patient = request[@"Patient"];
        [self sendNotificationReceiptToPatient:patient.objectId];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Notification sent to patient to rate." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self reloadData];
    }];
    
//    [self showWaiting:@"Processing Payment"];
//    NSNumber* totalAmount = request[@"TotalAmount"];
//    NSNumber* amountPaid = request[@"AmountPaid"];
//    double remainAmount = [totalAmount doubleValue] - [amountPaid doubleValue];
//    [[BrainTreeService defaultBraintree] makeSplitPayment:request[@"SubMerchantId"] amount:remainAmount paymentmethod:request[@"PaymentToken"] tocustomerId:request[@"CustomerId"] onDone:^(BOOL success, NSString * msg, NSString* transactionId) {
//        [self dismissWaiting];
//        if(success == TRUE)
//        {
//            request[@"PatientVisited"] = [NSNumber numberWithBool:YES];
//            request[@"AmountPaid"] = totalAmount;
//            request[@"TransactionId"] = transactionId;
//            request[@"requestStatus"] = @"FullPaid";
//            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                
//                NSString *title;
//                NSString *message;
//                
//                if (error){
//                    title = @"Error";
//                    message = error.userInfo[@"error"];
//                }else{
//                    title = @"";
//                    message = @"Notification sent to patient to rate.";
//                }
//                PFObject* patient = request[@"Patient"];
//                [self sendNotificationReceiptToPatient:patient.objectId];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [alert show];
//                [self reloadData];
//            }];
//        }
//        else
//        {
//            [self dismissWaiting];
//            UIAlertView *warningDialog = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [warningDialog show];
//        }
//    } onError:^(BOOL error) {
//        [self dismissWaiting];
//        UIAlertView *warningDialog = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We're sorry, you cannot accept at this time. Please try later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [warningDialog show];
//    }];
}

-(void)sendNotificationReceiptToPatient:(NSString*)objectId
{
    PFPush* push = [[PFPush alloc] init];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"Status" equalTo:@"Patient"];
    [userQuery whereKey:@"objectId" equalTo:objectId];
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:userQuery];
    [push setQuery:pushQuery];
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:@"Your receipt is there. Please login", @"alert", @"default", @"sound", nil];
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *  error) {
        if(!error)
        {
            NSLog(@"Sent notification to Patient");
        }
        else
        {
            NSLog(@"Sent notification to Patient failure");
        }
    }];
}

 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
     
       PFObject *request = [self.requests objectAtIndex:indexPath.row];
     
   
     
     [self setAnnotions:request];

 }



-(void)setAnnotions:(PFObject*)request {
    
        PFGeoPoint *userGeoPoint = request[@"Location"];
        CLLocationDegrees latitude=userGeoPoint.latitude ;
        CLLocationDegrees longitude=userGeoPoint.longitude;
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span ,span );
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
        [self.mapView setRegion:adjustedRegion animated:YES];
        JPSThumbnail *anotation = [[JPSThumbnail alloc] init];
        anotation.image = [UIImage imageNamed:@"patient"];
        anotation.title = request[@"Name"];
        anotation.subtitle = request[@"PhoneNumber"];
        anotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        //anotation.doctor = doctor;
        anotation.disclosureBlock = ^{
            
            
        };
    
    NSArray *anotatinos = @[anotation];
    [self.mapView addAnnotations:anotatinos];
    }




#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

#pragma -mark Impl Actions

- (IBAction)backButtonPressed:(id)sender {
    [self toogleMasterView:sender];
}

- (IBAction)onoffDoctorMapLocator:(UISwitch*)sender
{
    PFUser* doctor = [PFUser currentUser];
    doctor[@"isHideMap"]  = [NSNumber numberWithBool:!sender.on];
    [doctor saveInBackground];
}

@end
