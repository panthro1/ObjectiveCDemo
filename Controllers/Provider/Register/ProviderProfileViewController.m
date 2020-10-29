//
//  ProviderProfileViewController.m
//  Doctor
//
//  Created by Arora Apps 002 on 17/11/14.
//  Copyright (c) 2014 Thomas. All rights reserved.
//

#import "ProviderProfileViewController.h"
#import  <Parse/Parse.h>

@interface ProviderProfileViewController ()

@end

@implementation ProviderProfileViewController
@synthesize Nametxt,medicalLicensetxt,Addresstxt,address2txt,medicalSpecialitytxt,DriverLicensetxt,carmakeTxt,carinsurencetxt,medicalmalpracticetxt;
@synthesize popoverController;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
        if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (self.view.frame.size.height >=568)
            {
            [scrolView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+60)];
            }
            else
            {
                [scrolView setContentSize:CGSizeMake(self.view.frame.size.width, 580)];
            }
        }
        else
        {
            [scrolView setContentSize:CGSizeMake(self.view.frame.size.width, scrolView.frame.size.height)];
        }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UItextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==Nametxt)
    {
        [Addresstxt becomeFirstResponder];
    }
    else if (textField==Addresstxt)
    {
        [address2txt becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma -mark Location Delegates
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation.verticalAccuracy>0 && newLocation.verticalAccuracy < 100) {
        userLocation = newLocation;
        [locationManager stopUpdatingLocation];
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is some problem with location service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}

#pragma mark - Button Action
-(IBAction)savebtnClick:(id)sender
{
    
    if ([Nametxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Please enter your name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    if ([self.Username.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Please enter your username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    else if ([Addresstxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Please enter your address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([medicalLicensetxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Please enter your medical licence." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([medicalSpecialitytxt.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Please select your medical speciality." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([self.ChosePassword.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Please enter your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else if ([self.ConfirmPassword.text length]<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Please confirm your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    else if (![self.ChosePassword.text isEqualToString:self.ConfirmPassword.text])
    {
        [[[UIAlertView alloc]initWithTitle:@"Swurvin" message:@"Password does not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    else
    {
        NSData* data = UIImageJPEGRepresentation(medicalLicenseImage, 0.5f);
        PFFile *imageFilemedicallicense = [PFFile fileWithName:@"image.jpg" data:data];
        
        data = UIImageJPEGRepresentation(DriverLicenseImage, 0.5f);
        PFFile *imageFiledrivinglicense = [PFFile fileWithName:@"image.jpg" data:data];
        
        
        data = UIImageJPEGRepresentation(carmakeImage, 0.5f);
        PFFile *imageFilecarmakelicense = [PFFile fileWithName:@"image.jpg" data:data];
        
        data = UIImageJPEGRepresentation(carinsurenceImage, 0.5f);
        PFFile *imageFilecarinsuranxcelicense = [PFFile fileWithName:@"image.jpg" data:data];
      
        data = UIImageJPEGRepresentation(medicalmalpracticeImage, 0.5f);
        PFFile *imageFilemedicalpractice = [PFFile fileWithName:@"image.jpg" data:data];
        
        data = UIImageJPEGRepresentation(providerImage, 0.5f);
        PFFile *providePic = [PFFile fileWithName:@"image.jpg" data:data];
        
        
        
        
        
        PFUser *ProviderDetails = [PFUser user];
       // ProviderDetails[@"Username"] = self.Username.text;
        ProviderDetails.username=self.Username.text;
        ProviderDetails.password=self.ChosePassword.text;
       //_ChosePassword.secureTextEntry = YES;
        ProviderDetails[@"Name"] = Nametxt.text;
        ProviderDetails[@"Status"] = @"Provider";
        [ProviderDetails setObject:imageFilemedicallicense forKey:@"Medicalicense"];
        ProviderDetails[@"Address"]=Addresstxt.text;
        [ProviderDetails setObject:imageFiledrivinglicense forKey:@"DrvingLicense"];
        [ProviderDetails setObject:imageFilecarmakelicense forKey:@"Carmakeup"];
        [ProviderDetails setObject:imageFilecarinsuranxcelicense forKey:@"Carinsurancelicense"];
        [ProviderDetails setObject:imageFilemedicalpractice forKey:@"Medicalpractice"];
        [ProviderDetails setObject:providePic forKey:@"providePic"];
        
        if (userLocation) {
            PFGeoPoint *geoLocation = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            ProviderDetails [@"location"] = geoLocation;
        }
        
        
        [ProviderDetails signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                [[[UIAlertView alloc]initWithTitle:@"Registration Success" message:@"Successfully created your profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                
            }
            else
            {
                
                //Something bad has ocurred
                
                NSDictionary *errorDetails=[error userInfo];
                NSString *detail=[errorDetails objectForKey:@"error"];
                //Something bad has ocurred
                // NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:detail delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];            }
        }];
        
    }
    [self StopEdit];
}
-(void)StopEdit
{
     [medicalLicensetxt setUserInteractionEnabled:NO];
     [medicalSpecialitytxt setUserInteractionEnabled:NO];
     [DriverLicensetxt setUserInteractionEnabled:NO];
     [carmakeTxt setUserInteractionEnabled:NO];
     [carinsurencetxt setUserInteractionEnabled:NO];
     [medicalmalpracticetxt setUserInteractionEnabled:NO];
}
-(IBAction)medicalSpecialitySelect:(id)sender
{
        if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            NSArray *arr=[[NSMutableArray alloc]initWithObjects:@"Tow Truck Company", /*@"Internist",*/ nil];
            RSPickerView *picker1 = [[RSPickerView alloc]initWithOptions:arr];
            picker1.type = RSPickerTypeStandard;
            picker1.del = self;
            [picker1 showInView:self.view];
            [picker1 showInView:self.view];
        }
        else
        {
             medicalSpecialitytxt.text= @"Physician";
            UIButton *btn=sender;
            UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300,44)];
            pickerToolbar.barStyle = UIBarStyleBlackOpaque;
            [pickerToolbar sizeToFit];
//            NSMutableArray *barItems = [[NSMutableArray alloc] init];
//            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(popovercancle)];
//            [barItems addObject:doneBtn];
//            [pickerToolbar setItems:barItems animated:YES];
            UIViewController* popoverContent = [[UIViewController alloc] init];
            UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,300)];
            popoverView.backgroundColor = [UIColor whiteColor];
            [popoverView addSubview:pickerToolbar];
            popoverContent.view = popoverView;
            
            picView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
            picView.showsSelectionIndicator = YES;
            picView.delegate = self;
            picView.dataSource = self;
            [picView reloadAllComponents];
            [popoverView addSubview:picView];
            
            popoverContent.preferredContentSize = CGSizeMake(300,300);
            popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
            
            CGRect popoverRect = [self.view convertRect:[btn frame]
                                          fromView:[btn superview]];
            
            popoverRect.size.width = MIN(popoverRect.size.width, 100);
            popoverRect.origin.x  = popoverRect.origin.x;
            
            [popoverController presentPopoverFromRect:popoverRect
                                               inView:self.view
             permittedArrowDirections:UIPopoverArrowDirectionAny
             animated:YES];
        }
}
-(void)popovercancle
{
    if (popoverController != nil)
    {
        [popoverController dismissPopoverAnimated:YES];
        popoverController=nil;
    }
    [popoverController dismissPopoverAnimated:YES];
}
#pragma mark - PickerViewDelegateDatsource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}
- (IBAction)MedicalUpload:(id)sender {
}

- (IBAction)DriversLicenseUpload:(id)sender {
}

- (IBAction)CarMakeUpload:(id)sender {
}

- (IBAction)CarInsuranceUpload:(id)sender {
}

- (IBAction)MedicalMalpracticeUpload:(id)sender {
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch(row)
    {
        case 0:
        {
            return @"Physician";
            break;
        }
        case 1:
        {
            return @"Dentist";
            break;
        }
        case 2:
        {
            return @"Heart";
            break;
        }
        default:
            break;
    }
    return @"Heart";
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row)
    {
        case 0:
            medicalSpecialitytxt.text= @"Physician";
            break;
        case 1:
            medicalSpecialitytxt.text= @"Dentist";
            break;
        case 2:
            medicalSpecialitytxt.text= @"Heart";
            break;
            
        default:
            break;
    }
    
     [popoverController dismissPopoverAnimated:YES];
}

-(void)RSPicker:(RSPickerView *)picker didDismissWithSelection:(id)selection inTextField:(UITextField *)textField Response:(NSString *)response
{
    medicalSpecialitytxt.text=response;
}
#pragma mark - Image Select
- (IBAction)TakePhotoClick:(id)sender
{
    UIButton *btn1=sender;
    imgNameTag= btn1.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"SELECT MODEL IMAGE" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture",@"Choose from gallery", nil];
   	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   	actionSheet.alpha=1.0;
   	actionSheet.tag = 1;
   	UIButton *btn = (UIButton *)sender;
    [actionSheet showFromRect:btn.frame inView:self.view animated: YES];
}
#pragma mark - Action Sheet Delegate
#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self performSelectorOnMainThread:@selector(TakePicture) withObject:nil waitUntilDone:NO];
        }
            break;
        case 1:
        {
            [self performSelectorOnMainThread:@selector(Opengallery) withObject:nil waitUntilDone:NO];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - Open Camera
#pragma mark -
- (void)TakePicture
{
#if TARGET_IPHONE_SIMULATOR
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Doctor" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//    return;
#endif
    
    if (picker)
    {
        picker.delegate=nil;
        picker=nil;
    }
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)Opengallery
{
    if (picker)
    {
        picker.delegate=nil;
        picker=nil;
    }
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - Image Picker Delegate
#pragma mark -
-(void)imagePickerController:(UIImagePickerController*)picker2 didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        
        NSString *imageName = [imagePath lastPathComponent];
        NSLog(@"%@",imageName);
        switch (imgNameTag)
        {
            case 0:
                medicalLicensetxt.text=imageName;
                medicalLicenseImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                break;
            case 1:
                DriverLicensetxt.text=imageName;
                DriverLicenseImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                break;
            case 2:
                carmakeTxt.text=imageName;
                carmakeImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                break;
            case 3:
                carinsurencetxt.text=imageName;
                carinsurenceImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                break;
            case 4:
                medicalmalpracticetxt.text=imageName;
                medicalmalpracticeImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
            case 5:
            self.doctorTextField.text=imageName;
               // self.doctorImageView.image =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                providerImage =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                providerImageView.image = providerImage;
                
                break;
                
            default:
                break;
        }

        
        [self performSelectorOnMainThread:@selector(showImagName:) withObject:imageName waitUntilDone:NO];
       [picker2 dismissViewControllerAnimated:YES completion:nil];
    }
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)showImagName:(NSString*)name
{
    if (!name || [name isEqualToString:@""]) {
        name=@"image.png";
    }
    imgNameTag=5;
}
- (IBAction)MedicalLicenseUpload:(id)sender {
}

- (IBAction)DrivingLicenseUpload:(id)sender {
}

- (IBAction)CarMakeupUploadbutton:(id)sender {
}

- (IBAction)CarInsuranceUploadButton:(id)sender {
}

- (IBAction)MedicalPracticeUploadButton:(id)sender {
}
- (IBAction)doctorPhotoUpload:(id)sender {
    imgNameTag = 5;
    
    [self TakePicture];
    
//    NSData *imageData = UIImagePNGRepresentation(self.doctorImageView.image);
//    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
//    
//    PFUser *user = [PFUser currentUser];
//    user[@"doctorPhotoUpload"] = imageFile;
//    [user saveInBackground];
}
@end
