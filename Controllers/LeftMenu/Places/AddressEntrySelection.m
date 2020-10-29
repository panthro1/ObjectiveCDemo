//
//  AddressEntrySelection.m
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "AddressEntrySelection.h"
#import "AddressEntryCell.h"
#import "LPGoogleFunctions.h"
#import "LPImage.h"

NSString *const googleAPIBrowserKey = @"AIzaSyBG4rZqE-dQYu8kfOvujHFIDMCtKe3C1dg";//@"AIzaSyAcUg1WctW8aED2ypC_dvy9Qi07XKjACCA";

@interface AddressEntrySelection ()<LPGoogleFunctionsDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *_removeButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *_waitingIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *_iconSearchAdress;
@property (strong, nonatomic) IBOutlet UITextField *_homeAddressTextField;
@property (strong, nonatomic) IBOutlet UITableView *_addressEntryTableView;
@property (strong, nonatomic) IBOutlet UIImageView *_bgAddressEntry;
@property (nonatomic, strong) LPGoogleFunctions *googleFunctions;
@property (nonatomic, strong) NSMutableArray *placesList;

@end

@implementation AddressEntrySelection

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* searchText;
    if(_isAddHome)
    {
        __iconSearchAdress.image = [UIImage imageNamed:@"home_icon"];
        __homeAddressTextField.placeholder = @"Enter home address";
        searchText = [PFUser currentUser][@"addhomeAddress"];
        [__removeButton setTitle:@"REMOVE HOME" forState:UIControlStateNormal];
    }
    else
    {
        __iconSearchAdress.image = [UIImage imageNamed:@"work_icon"];
        __homeAddressTextField.placeholder = @"Enter work address";
        searchText = [PFUser currentUser][@"addworkAddress"];
        [__removeButton setTitle:@"REMOVE WORK" forState:UIControlStateNormal];
    }
    __addressEntryTableView.tableFooterView = [UIView new];
    __bgAddressEntry.hidden = YES;
    __homeAddressTextField.text = searchText;
    [__homeAddressTextField becomeFirstResponder];
    UITapGestureRecognizer* tapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tapEvent.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapEvent];
}

-(void)dismissKeyboard:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadPlacesAutocompleteForInput:__homeAddressTextField.text];
    if(__homeAddressTextField.text && ![__homeAddressTextField.text isEqualToString:@""])
    {
        __removeButton.hidden = NO;
    }
    else
    {
        __removeButton.hidden = YES;
    }
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - LPGoogleFunctions

- (LPGoogleFunctions *)googleFunctions
{
    if (!_googleFunctions) {
        _googleFunctions = [LPGoogleFunctions new];
        _googleFunctions.googleAPIBrowserKey = googleAPIBrowserKey;
        _googleFunctions.delegate = self;
        _googleFunctions.sensor = YES;
        _googleFunctions.languageCode = @"en";
    }
    return _googleFunctions;
}

- (void)loadPlacesAutocompleteForInput:(NSString *)input
{
    __waitingIndicator.hidden = NO;
    [__waitingIndicator startAnimating];
    [self.googleFunctions loadPlacesAutocompleteWithDetailsForInput:input offset:(int)[input length] radius:0 location:nil placeType:LPGooglePlaceTypeGeocode countryRestriction:nil successfulBlock:^(NSArray *placesWithDetails) {
        NSLog(@"successful");
        __waitingIndicator.hidden = YES;
        [__waitingIndicator stopAnimating];
        __bgAddressEntry.hidden = NO;
        self.placesList = [NSMutableArray arrayWithArray:placesWithDetails];
        [__addressEntryTableView reloadData];
    } failureBlock:^(LPGoogleStatus status) {
        NSLog(@"Error - Block: %@", [LPGoogleFunctions getGoogleStatus:status]);
        __waitingIndicator.hidden = YES;
        [__waitingIndicator stopAnimating];
        self.placesList = [NSMutableArray new];
        __bgAddressEntry.hidden = YES;
        [__addressEntryTableView reloadData];
    }];
}

#pragma mark - LPGoogleFunctions Delegate

- (void)googleFunctionsWillLoadPlacesAutocomplate:(LPGoogleFunctions *)googleFunctions forInput:(NSString *)input
{
    NSLog(@"willLoadPlacesAutcompleteForInput: %@", input);
}

- (void)googleFunctions:(LPGoogleFunctions *)googleFunctions didLoadPlacesAutocomplate:(LPPlacesAutocomplete *)placesAutocomplate
{
    NSLog(@"didLoadPlacesAutocomplete - Delegate");
}

- (void)googleFunctions:(LPGoogleFunctions *)googleFunctions errorLoadingPlacesAutocomplateWithStatus:(LPGoogleStatus)status
{
    NSLog(@"errorLoadingPlacesAutocomplateWithStatus - Delegate: %@", [LPGoogleFunctions getGoogleStatus:status]);
}

#pragma mark - Search Controller

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self loadPlacesAutocompleteForInput:textField.text];
    return TRUE;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self loadPlacesAutocompleteForInput:textField.text];
    return TRUE;
}

#pragma -mark Impl UITableView datasource & delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.placesList count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressEntryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddressEntryCellId"];
    LPPlaceDetails *placeDetails = (LPPlaceDetails *)[self.placesList objectAtIndex:indexPath.row];
    cell._nameLbl.text = placeDetails.name;
    cell._addressLbl.text = placeDetails.formattedAddress;
    [cell setImageForCellfromURL:placeDetails.icon withColor:[UIColor colorWithRed:(170.0/255.0) green:(170.0/255.0) blue:(170.0/255.0) alpha:1.0]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser* user = [PFUser currentUser];
    LPPlaceDetails *placeDetails = (LPPlaceDetails *)[self.placesList objectAtIndex:indexPath.row];
    if (_isAddHome)
    {
        user[@"addhomeAddress"] = placeDetails.name;
    }
    else
    {
        user[@"addworkAddress"] = placeDetails.name;
    }
    __waitingIndicator.hidden = NO;
    [__waitingIndicator startAnimating];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        __waitingIndicator.hidden = YES;
        [__waitingIndicator stopAnimating];
        if(succeeded)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
}

#pragma -Mark Impl Actions

- (IBAction)cancelSearchAddress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)removeAddressAction:(id)sender {
    PFUser* user = [PFUser currentUser];
    if (_isAddHome)
    {
        user[@"addhomeAddress"] = @"";
    }
    else
    {
        user[@"addworkAddress"] = @"";
    }
    [self showWaiting];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dismissWaiting];
        if(succeeded)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
