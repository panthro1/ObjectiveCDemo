//
//  PaymentViewController.m
//  doctor
//
//  Created by Thomas.Woodfin on 8/12/15.
//  Copyright (c) 2015 Thomas. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentCell.h"
#import <Braintree/Braintree.h>
#import <Braintree/BTPayPalPaymentMethod.h>
#import <Braintree/BTCardPaymentMethod.h>
#import "CardIOPaymentViewController.h"
#import <Braintree/BTDropInContentView.h>
#import <CardIO/CardIOCreditCardInfo.h>

@interface PaymentViewController () <UITableViewDataSource, UITableViewDelegate,BTDropInViewControllerDelegate, CardIOPaymentViewControllerDelegate, PaymentCellDelegate>
{
    NSMutableArray* _paymentsArray;
    BTDropInViewController *dropInViewController;
    UINavigationController *navigationController;
    BTPaymentMethod* paymentMethod;
    UITableViewCell* _cellSelected;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *_waitingIndicator;
@property (weak, nonatomic) IBOutlet UITableView *PaymentTableView;
@property (weak, nonatomic) IBOutlet UILabel* TitleLbl;
@property (nonatomic, strong) Braintree *braintree;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.braintree = [Braintree braintreeWithClientToken:CLIENT_TOKEN];
    __waitingIndicator.hidden = YES;
    _PaymentTableView.tableFooterView = [UIView new];
    [self getPayments];
    if(_isSelectPayment)
    {
        _TitleLbl.text = @"SELECT PAYMENT";
    }
    else
    {
        _TitleLbl.text = @"PAYMENT";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanCardAction) name:@"ScanCard" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark BrainTree Impl

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        [self addCardFormWithInfo:cardInfo];
        [self presentViewController:navigationController animated:NO completion:nil];
    }];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:navigationController animated:NO completion:nil];
    }];
}

-(void)scanCardAction
{
    [navigationController dismissViewControllerAnimated:NO completion:^{
        CardIOPaymentViewController *v = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
        
        [self presentViewController:v
                           animated:YES
                         completion:nil];
    }];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod1 {
    paymentMethod = paymentMethod1;
    PFObject* userhasPayment = [self isExistedPaymentDefault];
    PFObject* payment = [PFObject objectWithClassName:@"Payment"];
    PFUser* user = [PFUser currentUser];
    CustomerInfo* cus = [CustomerInfo new];
    cus.FirstName = user[@"FirstName"];
    cus.LastName = user[@"LasttName"];
    cus.Email = user[@"email"];
    cus.PhoneNumber = user[@"PhoneNumber"];
    [self showWaiting];
    if(userhasPayment)
    {
        payment[@"CustomerId"] = user[@"CustomerId"];
        [[BrainTreeService defaultBraintree] addPaymentMethod:paymentMethod.nonce tocustomerId:user[@"CustomerId"] onDone:^(BOOL success, NSString *paymentToken, NSString* maskedNumber) {
            if(success)
            {
                payment[@"PaymentToken"] = paymentToken;
                if([paymentMethod isKindOfClass:[BTPayPalPaymentMethod class]])
                {
                    payment[@"PaymentName"] = ((BTPayPalPaymentMethod*)paymentMethod).email;
                    payment[@"PaymentType"] = @"PayPal";
                    
                }
                else
                {
                    payment[@"PaymentName"] = maskedNumber;
                    payment[@"PaymentType"] = ((BTCardPaymentMethod*)paymentMethod).typeString;
                }
                if(![self isExistedPaymentDefault])
                {
                    payment[@"isSelected"] = [NSNumber numberWithBool:YES];
                }
                [payment save];
                PFRelation* relation = [user relationForKey:@"Payment"];
                [relation addObject:payment];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self dismissWaiting];
                    if(succeeded)
                    {
                        [self getPayments];
                    }
                    else
                    {
                        
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot add payment at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                    }
                }];
            }
            else
            {
                [self dismissWaiting];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot add payment at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        } onError:^(BOOL error) {
            [self dismissWaiting];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot add payment at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }];
    }
    else //Paypal first time
    {
        [[BrainTreeService defaultBraintree] creatCustomerInfo:cus onDone:^(BOOL success, NSString * customerId) {
            if(success)
            {
                payment[@"CustomerId"] = customerId;
                [[BrainTreeService defaultBraintree] addPaymentMethod:paymentMethod.nonce tocustomerId:customerId onDone:^(BOOL success, NSString *paymentToken, NSString* maskedNumber) {
                    if(success)
                    {
                        payment[@"PaymentToken"] = paymentToken;
                        if([paymentMethod isKindOfClass:[BTPayPalPaymentMethod class]])
                        {
                            payment[@"PaymentName"] = ((BTPayPalPaymentMethod*)paymentMethod).email;
                            payment[@"PaymentType"] = @"PayPal";
                            
                        }
                        else
                        {
                            payment[@"PaymentName"] = maskedNumber;//cardForm.number;
                            payment[@"PaymentType"] = ((BTCardPaymentMethod*)paymentMethod).typeString;
                        }
                        payment[@"isSelected"] = [NSNumber numberWithBool:YES];
                        [payment save];
                        PFRelation* relation = [user relationForKey:@"Payment"];
                        [relation addObject:payment];
                        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [self dismissWaiting];
                            if(succeeded)
                            {
                                [self getPayments];
                            }
                            else
                            {
                                
                                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot add payment at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                [errorAlertView show];
                            }
                        }];
                    }
                    else
                    {
                        [self dismissWaiting];
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot add payment at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                    }
                } onError:^(BOOL error) {
                    [self dismissWaiting];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot add payment at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }];
            }
            else
            {
                [self dismissWaiting];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot add payment at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
            
        } onError:^(BOOL error) {
            [self dismissWaiting];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Swurvin" message:@"We are sorry, we cannot add payment at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardFormWithInfo:(CardIOCreditCardInfo *)info {
    //Fix later
//    BTUICardFormView *cardForm = dropInViewController.dropInContentView.;
//
//    if (info) {
//        cardForm.number = info.cardNumber;
//        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//        dateComponents.month = info.expiryMonth;
//        dateComponents.year = info.expiryYear;
//        dateComponents.calendar = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
//        [cardForm setExpirationDate:dateComponents.date];
//    }
    
}

#pragma -mark Impl UITableView datasource & delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _paymentsArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row != _paymentsArray.count - 1) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject* object = _paymentsArray[indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                [self getPayments];
            }
        }];
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCellId"];
     cell.PaymentDelegate = self;
    [cell blindDataToShow:_paymentsArray[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)paymentSelected:(UITableViewCell *)cell
{
    _cellSelected = cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _paymentsArray.count - 1) {
        dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
        //Fixed later
        //dropInViewController.dropInContentView.hasAvailableScanCard = 3;
        dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                              target:self
                                                                                                              action:@selector(dropInViewControllerDidCancel:)];
        dropInViewController.callToActionText = @"Done";
        dropInViewController.title = @"ADD PAYMENT";
        [dropInViewController fetchPaymentMethods];
        navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        UITableViewCell* cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        PFObject* object = _paymentsArray[indexPath.row];
        object[@"isSelected"] = [NSNumber numberWithBool:YES];
        [object saveInBackground];
        if(_cellSelected)
        {
            NSIndexPath* prevIndexPath = [tableView indexPathForCell:_cellSelected];
            PFObject* prevObject = _paymentsArray[prevIndexPath.row];
            prevObject[@"isSelected"] = [NSNumber numberWithBool:NO];
            [prevObject saveInBackground];
            _cellSelected.accessoryType = UITableViewCellAccessoryNone;
        }
        _cellSelected = cell;
    }
}


#pragma -mark Impl Actions

- (IBAction)closeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark Helper methods

- (void) getPayments {
    __waitingIndicator.hidden = NO;
    [__waitingIndicator startAnimating];
    PFRelation* paymentRelation = [[PFUser currentUser] relationForKey:@"Payment"];
    [paymentRelation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        __waitingIndicator.hidden = YES;
        [__waitingIndicator stopAnimating];
        if(!_paymentsArray)
        {
            _paymentsArray = [NSMutableArray new];
        }
        [_paymentsArray removeAllObjects];
        if(objects.count > 0)
        {
            [_paymentsArray addObjectsFromArray:objects];
        }
        [_paymentsArray addObject:@"ADD PAYMENT"];
        [_PaymentTableView reloadData];
    }];
}

-(PFObject*) isExistedPaymentDefault
{
    PFRelation* paymentRelation = [[PFUser currentUser] relationForKey:@"Payment"];
    PFQuery* query = paymentRelation.query;
    [query whereKey:@"isSelected" equalTo:[NSNumber numberWithBool:YES]];
    NSArray* result = [query findObjects];
    if(result && result.count > 0)
    {
        return [result lastObject];
    }
    return nil;
}


@end
