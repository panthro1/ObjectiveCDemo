//
//  MenuViewController.m
//  doctor
//
//  Created by Thomas Woodfin on 12/3/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "MenuViewController.h"
#import "Request_patientViewController.h"
#import "JPSThumbnail.h"
#import "JPSThumbnailAnnotation.h"
#import <AddressBookUI/AddressBookUI.h>
#import "PaymentViewController.h"


@interface MenuViewController ()<MKMapViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>
{
    bool _isShowCurrentLocation;
    UITextField* pickupLocation;
    UIButton* nearButton;
    UIButton* selectDoctorButton;
    PFUser *selectedDoctor;
    CLLocationManager* locationManager;
    BOOL _selectedPickup;
    NSTimer* _checkDoctorTimer;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Store User in installation
    PFInstallation* installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    _mapViewHome.delegate = self;
    [menuButton setImage:MENU_ICO forState:UIControlStateNormal];
    UIImageView* marker = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_mapViewHome.frame) - 16, CGRectGetMidY(_mapViewHome.frame) - 16, 32, 32)];
    marker.center = _mapViewHome.center;
    marker.image = [UIImage imageNamed:@"marker"];
    [self.view addSubview:marker];
    selectDoctorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectDoctorButton.backgroundColor = [UIColor orangeColor];
    selectDoctorButton.layer.cornerRadius = 10;
    selectDoctorButton.frame = CGRectMake((IPAD_VERSION ?  60 : 10), CGRectGetMidY(_mapViewHome.frame) - (IPAD_VERSION ? 100 : 70), CGRectGetWidth(self.view.frame) - (IPAD_VERSION ?  120 : 20), (IPAD_VERSION ? 58 : 44));
    [selectDoctorButton setTitle:@"Select Doctor Visit Location" forState:UIControlStateNormal];
    [selectDoctorButton addTarget:self action:@selector(pickupDoctorLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectDoctorButton];
    
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* next = [UIImage imageWithIcon:@"fa-chevron-circle-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    [nextButton setImage:next forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - (IPAD_VERSION ? 98 : 40), CGRectGetMidY(selectDoctorButton.frame) - (IPAD_VERSION ? 20 : 15), (IPAD_VERSION ? 40 : 30), (IPAD_VERSION ? 40 : 30));
    [nextButton addTarget:self action:@selector(pickupDoctorLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(0, 0)];
    [trianglePath addLineToPoint:CGPointMake((IPAD_VERSION ? 20 : 15),(IPAD_VERSION ? 16 : 12))];
    [trianglePath addLineToPoint:CGPointMake((IPAD_VERSION ? 40 : 30), 0)];
    [trianglePath closePath];
    
    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];
    triangleMaskLayer.fillColor = [UIColor orangeColor].CGColor;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_mapViewHome.frame) - (IPAD_VERSION ? 20 : 15),selectDoctorButton.frame.origin.y + (IPAD_VERSION ? 58 : 44), (IPAD_VERSION ? 40 : 30), 15)];
    
    view.backgroundColor = [UIColor clearColor];
    [view.layer addSublayer:triangleMaskLayer];
    [self.view addSubview:view];
    
    //Pick location
    pickupLocation = [[UITextField alloc] initWithFrame:CGRectMake(10, (IPAD_VERSION ? 90 : 50), CGRectGetWidth(self.view.frame) - 20, 50)];
    pickupLocation.layer.cornerRadius = 10;
    pickupLocation.delegate = self;
    pickupLocation.backgroundColor = [UIColor lightGrayColor];
    pickupLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
    pickupLocation.textColor = [UIColor whiteColor];
    pickupLocation.returnKeyType = UIReturnKeyGo;
    pickupLocation.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pickupLocation];
    //Current location
    nearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* location = [UIImage imageWithIcon:@"fa-location-arrow" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:25];
    [nearButton setImage:location forState:UIControlStateNormal];
    nearButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 48, CGRectGetHeight(_mapViewHome.frame) - 50, 48, 48);
    [self.view addSubview:nearButton];
    nearButton.hidden = YES;
    [nearButton addTarget:self action:@selector(currentLocation:) forControlEvents:UIControlEventTouchUpInside];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    UITapGestureRecognizer* tapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePaymentMethod:)];
    [paymentView addGestureRecognizer:tapEvent];
    _checkDoctorTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshDoctors) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    selectedDoctor = nil;
    _confirmView.hidden = YES;
    paymentView.hidden = YES;
    _requestDoctor.hidden = YES;
    __block CGRect frame = paymentName.frame;
    frame.origin.x = 53;
    paymentName.frame = frame;
    nearButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 48, CGRectGetHeight(_mapViewHome.frame) - 50, 48, 48);
    [locationManager startUpdatingLocation];
    PFRelation* paymentRelation = [[PFUser currentUser] relationForKey:@"Payment"];
    PFQuery* query = paymentRelation.query;
    [query whereKey:@"isSelected" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count > 0)
        {
            changeLbl.hidden = NO;
            PFObject* object = objects[0];
            if ([object[@"PaymentType"] isEqualToString:@"PayPal"]) {
                paymentIcon.image = [UIImage imageNamed:@"paypal"];
            }
            else
            {
                paymentIcon.image = [UIImage imageNamed:@"card"];
            }
            paymentName.text = object[@"PaymentName"];
        }
        else
        {
            frame.origin.x = 43;
            paymentName.frame = frame;
            paymentName.text = @"ADD PAYMENT";
            paymentIcon.image = [UIImage imageNamed:@"add_icon"];
            changeLbl.hidden = YES;
        }
    }];
}

-(void)changePaymentMethod:(UITapGestureRecognizer*)sender
{
    PaymentViewController* paymentCL = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    paymentCL.isSelectPayment = TRUE;
    [self.navigationController pushViewController:paymentCL animated:YES];
}

-(IBAction)pickupDoctorLocation:(id)sender
{
    _selectedPickup = TRUE;
    if(_confirmView.hidden)
    {
        _confirmView.hidden = NO;
        paymentView.hidden = NO;
        _requestDoctor.hidden = NO;
        //NSLog(@"Zoom - OUT");
        MKCoordinateRegion region;
        //Set Zoom level using Span
        MKCoordinateSpan span;
        region.center= _mapViewHome.region.center;
        span.latitudeDelta = _mapViewHome.region.span.latitudeDelta /5;
        span.longitudeDelta = _mapViewHome.region.span.longitudeDelta /5;
        region.span = span;
        [_mapViewHome setRegion:region animated:TRUE];
        nearButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 48, CGRectGetHeight(_mapViewHome.frame) - 102, 48, 48);
        CGRect frame = paymentView.frame;
        frame.origin.y = nearButton.frame.origin.y - frame.size.height - 5;
        paymentView.frame = frame;
        _confirmView.alpha = 0;
        _requestDoctor.alpha = 0;
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            _confirmView.alpha = 1;
            _requestDoctor.alpha = 1;
        } completion:^(BOOL finished)
         {
             
         }];
    }
    else
    {
        nearButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 48, CGRectGetHeight(_mapViewHome.frame) - 50, 48, 48);
        _confirmView.alpha = 1;
        _requestDoctor.alpha = 1;
        //NSLog(@"Zoom - OUT");
        MKCoordinateRegion region;
        //Set Zoom level using Span
        MKCoordinateSpan span;
        region.center= _mapViewHome.region.center;
        span.latitudeDelta = _mapViewHome.region.span.latitudeDelta *5;
        span.longitudeDelta = _mapViewHome.region.span.longitudeDelta *5;
        region.span = span;
        [_mapViewHome setRegion:region animated:TRUE];
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            _confirmView.alpha = 0;
            _requestDoctor.alpha = 0;
            
        } completion:^(BOOL finished)
         {
             _confirmView.hidden = YES;
             paymentView.hidden = YES;
             _requestDoctor.hidden = YES;
         }];
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:textField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        _selectedPickup = TRUE;
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if (placemark != nil) {
            MKCoordinateRegion region;
            region.center.latitude = placemark.region.center.latitude;
            region.center.longitude = placemark.region.center.longitude;
            MKCoordinateSpan span;
            double radius = placemark.region.radius / 1000; // convert to km
            span.latitudeDelta = radius / 112.0;
            region.span = span;
            [_mapViewHome setRegion:region animated:YES];
            [self fetchDoctors];
        }
    }];
    return YES;
}

#pragma - mark Map

- (void)fetchDoctors {
    
    //Query User
    PFGeoPoint* geoPoint = [PFGeoPoint geoPointWithLatitude:_mapViewHome.centerCoordinate.latitude longitude:_mapViewHome.centerCoordinate.longitude];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"Status" equalTo:@"Provider"];//Only Doctors
    //[userQuery whereKey:@"isHideMap" equalTo:[NSNumber numberWithBool:FALSE]];//Only Doctors
    [userQuery whereKey:@"location" nearGeoPoint:geoPoint withinMiles:60.0];//60 miles
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* result = [NSMutableArray arrayWithArray:objects];
            [result filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                NSObject* hideMap = evaluatedObject[@"isHideMap"];
                return [hideMap isEqual:[NSNumber numberWithBool:FALSE]] || [hideMap isEqual:[NSNull null]] || hideMap == nil;
            }]];
            doctors = result;
            
            if(doctors.count > 0)
            {
                [selectDoctorButton setTitle:@"Select RoadSide Provider Visit Location" forState:UIControlStateNormal];
                [self setAnnotionsWithList:doctors];
            }
            else
            {
                //No available
                [_mapViewHome removeAnnotations:[_mapViewHome annotations]];
                [selectDoctorButton setTitle:@"No RoadSide Providers available" forState:UIControlStateNormal];
            }
            
        } else {
            
            //No available
            [_mapViewHome removeAnnotations:[_mapViewHome annotations]];
            [selectDoctorButton setTitle:@"No RoadSide Providers available" forState:UIControlStateNormal];
        }
    }];
    
    
    //Query 2
//    PFQuery *userQuery2 = [PFUser query];
//    [userQuery2 whereKey:@"Status" equalTo:@"Provider"];//Only Doctors
//    [userQuery2 whereKey:@"isHideMap" equalTo:[NSNull null]];//Only Doctors
//    [userQuery2 whereKey:@"location" nearGeoPoint:geoPoint withinMiles:60.0];//60 miles
//    //Or
//    PFQuery* queryOr = [PFQuery orQueryWithSubqueries:@[userQuery,userQuery2]];
//    [queryOr findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            doctors = objects;
//            if(doctors.count > 0)
//            {
//                [selectDoctorButton setTitle:@"Select Doctor Visit Location" forState:UIControlStateNormal];
//                [self setAnnotionsWithList:doctors];
//            }
//            else
//            {
//                //No available
//                [_mapViewHome removeAnnotations:[_mapViewHome annotations]];
//                [selectDoctorButton setTitle:@"No Tow Trucks available" forState:UIControlStateNormal];
//            }
//            
//        } else {
//            
//            //No available
//            [_mapViewHome removeAnnotations:[_mapViewHome annotations]];
//            [selectDoctorButton setTitle:@"No Tow Trucks available" forState:UIControlStateNormal];
//        }
//    }];
    
    
}

- (void) refreshDoctors {
    //Query User
    PFGeoPoint* geoPoint = [PFGeoPoint geoPointWithLatitude:_mapViewHome.centerCoordinate.latitude longitude:_mapViewHome.centerCoordinate.longitude];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"Status" equalTo:@"Provider"];//Only Doctors
    //[userQuery whereKey:@"isHideMap" equalTo:[NSNumber numberWithBool:FALSE]];//Only Doctors
    [userQuery whereKey:@"location" nearGeoPoint:geoPoint withinMiles:60.0];//60 miles
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* result = [NSMutableArray arrayWithArray:objects];
            [result filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                NSObject* hideMap = evaluatedObject[@"isHideMap"];
                return [hideMap isEqual:[NSNumber numberWithBool:FALSE]] || [hideMap isEqual:[NSNull null]] || hideMap == nil;
            }]];
            if (result.count != doctors.count) {
                doctors = result;
                [_mapViewHome removeAnnotations:[_mapViewHome annotations]];
                if(doctors.count > 0)
                {
                    [selectDoctorButton setTitle:@"Select RoadSide Provider Visit Location" forState:UIControlStateNormal];
                    [self setAnnotionsWithList:doctors];
                }
                else
                {
                    //No available
                    [selectDoctorButton setTitle:@"No RoadSide Providers available" forState:UIControlStateNormal];
                }
            } else {
                BOOL flag = TRUE;
                for (PFObject* obj1 in result) {
                    for (PFObject* obj2 in doctors) {
                        if(![obj1.objectId isEqualToString:obj2.objectId]) {
                            flag = FALSE;
                            break;
                        }
                    }
                }
                if(!flag) {
                    doctors = result;
                    [_mapViewHome removeAnnotations:[_mapViewHome annotations]];
                    if(doctors.count > 0)
                    {
                        [selectDoctorButton setTitle:@"Select RoadSide Provider Visit Location" forState:UIControlStateNormal];
                        [self setAnnotionsWithList:doctors];
                    }
                    else
                    {
                        //No available
                        [selectDoctorButton setTitle:@"No RoadSide Providers available" forState:UIControlStateNormal];
                    }
                }
            }
        }
    }];
    
    
    //Query 2
//    PFQuery *userQuery2 = [PFUser query];
//    [userQuery2 whereKey:@"Status" equalTo:@"Provider"];//Only Doctors
//    [userQuery2 whereKey:@"isHideMap" equalTo:[NSNull null]];//Only Doctors
//    [userQuery2 whereKey:@"location" nearGeoPoint:geoPoint withinMiles:60.0];//60 miles
//    //Or
//    PFQuery* queryOr = [PFQuery orQueryWithSubqueries:@[userQuery,userQuery2]];
//    [queryOr findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            
//            if (objects.count != doctors.count) {
//                doctors = objects;
//                [_mapViewHome removeAnnotations:[_mapViewHome annotations]];
//                if(doctors.count > 0)
//                {
//                    [selectDoctorButton setTitle:@"Select Doctor Visit Location" forState:UIControlStateNormal];
//                    [self setAnnotionsWithList:doctors];
//                }
//                else
//                {
//                    //No available
//                    [selectDoctorButton setTitle:@"No Doctors available" forState:UIControlStateNormal];
//                }
//            } else {
//                BOOL flag = TRUE;
//                for (PFObject* obj1 in objects) {
//                    for (PFObject* obj2 in doctors) {
//                        if(![obj1.objectId isEqualToString:obj2.objectId]) {
//                            flag = FALSE;
//                            break;
//                        }
//                    }
//                }
//                if(!flag) {
//                    doctors = objects;
//                    [_mapViewHome removeAnnotations:[_mapViewHome annotations]];
//                    if(doctors.count > 0)
//                    {
//                        [selectDoctorButton setTitle:@"Select Doctor Visit Location" forState:UIControlStateNormal];
//                        [self setAnnotionsWithList:doctors];
//                    }
//                    else
//                    {
//                        //No available
//                        [selectDoctorButton setTitle:@"No Tow Trucks available" forState:UIControlStateNormal];
//                    }
//                }
//            }
//        }
//    }];
}

-(void)setAnnotionsWithList:(NSArray *)list
{
    for (PFUser *doctor in list) {
        BOOL flag = FALSE;
        if([doctor[@"isHideMap"] boolValue] == TRUE) {
            for (id item in [_mapViewHome annotations])
            {
                if ([item isKindOfClass:[MKUserLocation class]]) continue;
                if( [((JPSThumbnailAnnotation*)item).thumbnail.doctor.objectId isEqualToString:doctor.objectId])
                {
                    [_mapViewHome removeAnnotation:item];
                    break;
                }
            }
            continue;
        }
        for (id item in [_mapViewHome annotations])
        {
            if ([item isKindOfClass:[MKUserLocation class]]) continue;
            if( [((JPSThumbnailAnnotation*)item).thumbnail.doctor.objectId isEqualToString:doctor.objectId])
            {
                flag = TRUE;
                break;
            }
        }
        if(!flag)
        {
            // User's location
            PFGeoPoint *userGeoPoint = doctor[@"location"];
            CLLocationDegrees latitude=userGeoPoint.latitude ;
            CLLocationDegrees longitude=userGeoPoint.longitude;
            JPSThumbnail *anotation = [[JPSThumbnail alloc] init];
            anotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            anotation.doctor = doctor;
            anotation.disclosureBlock = ^{
                
                selectedDoctor = anotation.doctor;
            };
            anotation.pinColor = MKPinAnnotationColorGreen;
            [_mapViewHome addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:anotation]];
        }
    }
}

-(IBAction)currentLocation:(id)sender
{
    double miles = 5.0;
    double scalingFactor = ABS( (cos(2 * M_PI * _mapViewHome.userLocation.location.coordinate.latitude / 360.0) ));
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    MKCoordinateRegion region;
    region.span = span;
    region.center = _mapViewHome.userLocation.location.coordinate;
    [_mapViewHome setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation.verticalAccuracy > 0 && newLocation.verticalAccuracy < 500)
    {
        [locationManager stopUpdatingLocation];
        double miles = 5.0;
        double scalingFactor = ABS( (cos(2 * M_PI * newLocation.coordinate.latitude / 360.0) ));
        MKCoordinateSpan span;
        span.latitudeDelta = miles/69.0;
        span.longitudeDelta = miles/(scalingFactor * 69.0);
        MKCoordinateRegion region;
        region.span = span;
        region.center = newLocation.coordinate;
        [_mapViewHome setRegion:region animated:YES];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@", [error description]);
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation1
{
    if(!_isShowCurrentLocation)
    {
        _isShowCurrentLocation = true;
        double miles = 5.0;
        double scalingFactor = ABS( (cos(2 * M_PI * _mapViewHome.userLocation.location.coordinate.latitude / 360.0) ));
        MKCoordinateSpan span;
        span.latitudeDelta = miles/69.0;
        span.longitudeDelta = miles/(scalingFactor * 69.0);
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = _mapViewHome.userLocation.location.coordinate;
        [_mapViewHome setRegion:region animated:YES];
    }
}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
     NSLog(@"didFailWithError %@", [error description]);
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        ((MKUserLocation *)annotation).title = nil;
    }
    
    MKAnnotationView *a = [ [ MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    //  a.title = @"test";
    if ( a == nil )
        a = [ [ MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier: @"currentloc" ];
    
    NSLog(@"%f",a.annotation.coordinate.latitude);
    NSLog(@"%f",a.annotation.coordinate.longitude);
    
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        //[((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        //[((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
        
    }
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if(!_selectedPickup)
    {
        pickupLocation.text = @"Go To Pin";
    }
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(_selectedPickup)
    {
        _selectedPickup = FALSE;
        return;
    }
    if(CLCOORDINATES_EQUAL2(_mapViewHome.centerCoordinate,_mapViewHome.userLocation.location.coordinate))
    {
        nearButton.hidden = YES;
    }
    else
    {
        nearButton.hidden = NO;
    }
    
    MKCoordinateRegion mapRegion;
    // set the center of the map region to the now updated map view center
    mapRegion.center = mapView.centerCoordinate;
    // get the lat & lng of the map region
    double lat = mapRegion.center.latitude;
    double lng = mapRegion.center.longitude;
    NSString* latLng = [NSString stringWithFormat:@"%f,%f", lat, lng];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue, ^{
        NSString* address = [self getAddressFromLatLong:latLng];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray* compoments = [address componentsSeparatedByString:@","];
            if(compoments.count > 1)
            {
                pickupLocation.text = [NSString stringWithFormat:@"%@, %@",compoments[0], compoments[1]];
            }
            else if(compoments.count == 1)
            {
                pickupLocation.text = [NSString stringWithFormat:@"%@",compoments[0]];;
            }
            [self fetchDoctors];
        });
    });
}

-(NSString*)getAddressFromLatLong : (NSString *)latLng {
    
    NSString *esc_addr =  [latLng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=true&latlng=%@", esc_addr];
    NSError* error;
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:&error];
    if(result)
    {
        NSMutableDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *dataArray = (NSMutableArray *)[data valueForKey:@"results" ];
        if (dataArray.count == 0) {
            return @"Go To Pin";
        }else{
            for (id firstTime in dataArray) {
                NSString *jsonStr1 = [firstTime valueForKey:@"formatted_address"];
                return jsonStr1;
            }
        }
    }
    
    return @"Go To Pin";
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState;
{
    NSLog(@"pin Drag");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        PaymentViewController* paymentCL = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        paymentCL.isSelectPayment = TRUE;
        [self.navigationController pushViewController:paymentCL animated:YES];
    }
}

#pragma -mark Actions

- (IBAction)btn_Menu:(id)sender {
    [self toogleMasterView: sender];
}

-(IBAction)requestDoctor:(id)sender
{
    PFUser* current = [PFUser currentUser];
    NSString* firstName = current[@"FirstName"];
    NSString *firstNametrimmedString = [firstName stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* lastName = current[@"LasttName"];
    NSString *lastNametrimmedString = [lastName stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* phoneNumber = current[@"PhoneNumber"];
    NSString *phoneNumbertrimmedString = [phoneNumber stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* email = current[@"emailaddress"] ;
    NSString *emailtrimmedString = [email stringByTrimmingCharactersInSet:
                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* address = current[@"Address"] ;
    NSString *addresstrimmedString = [address stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!firstNametrimmedString || [firstNametrimmedString isEqualToString:@""] ||
       !lastNametrimmedString || [lastNametrimmedString isEqualToString:@""] ||
       !phoneNumbertrimmedString || [phoneNumbertrimmedString isEqualToString:@""] ||
       !emailtrimmedString || [emailtrimmedString isEqualToString:@""] ||
       !addresstrimmedString || [addresstrimmedString isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please fill out your profile prior to requesting roadside." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil
                              ];
        [alert show];
        return;
    }
    
    if([paymentName.text isEqualToString:@"ADD PAYMENT"])
    {
        UIAlertView* warningAlert = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"Please add payment method." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [warningAlert show];
    }
    else
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        Request_patientViewController* requestDoctor = [mainStoryboard instantiateViewControllerWithIdentifier:(IPAD_VERSION ? @"Request_patientViewController" : @"Request_patientViewControlleriPhone")];
        MasterDetailViewController* masterDetail = [mainStoryboard instantiateViewControllerWithIdentifier: @"MasterDetailViewControllerId"];
        masterDetail.ignoreAddMainMenu = TRUE;
        requestDoctor.currentUserAddress =  pickupLocation.text;
        requestDoctor.doctors = doctors;
        [masterDetail setCenterViewControllerWithMasterDetail:requestDoctor];
        [self.navigationController pushViewController:masterDetail animated:YES];
    }
    
}

@end
