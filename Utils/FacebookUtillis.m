//
//  FacebookUtillis.m
//  Glabber
//
//  Created by Raghuveer Singh on 25/01/14.
//  Copyright (c) 2014 foxinfosoft. All rights reserved.
//

#import "FacebookUtillis.h"
#import "AppDelegate.h"

#define FBSessionStateSucessfull @"FBSessionStateSucessfull"
#define FBSessionStateFailed @"FBSessionStateFailed"
#define FBSession_Permission_Denied @"PERMISSIONDENIED"
#define FBSession_Permission_Granted @"PERMISSIONGRANTED"
@implementation FacebookUtillis

+(FacebookUtillis*)sharedInstance
{
	static dispatch_once_t pred;
	static FacebookUtillis *sharedInstance = nil;
	dispatch_once(&pred, ^{
		sharedInstance = [[FacebookUtillis alloc] init];
	});
	return sharedInstance;
}
//sohan
-(void)loginFacebook
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        
        if (!user) {
            [self handleAuthError:error];
            if (self.delegate)
            {
                [_delegate facebookCallBack:NO];
            }
        } else {
            if (user.isNew) {
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        [[PFUser currentUser] setObject:result[@"name"] forKey:@"Name"];
                        [[PFUser currentUser] setObject:result[@"email"] forKey:@"email"];
                        [[PFUser currentUser] setObject:result[@"last_name"] forKey:@"LasttName"];
                        [[PFUser currentUser] setObject:result[@"first_name"] forKey:@"FirstName"];
                        [[PFUser currentUser] saveInBackground];
                    }
                }];
            } else {
                NSLog(@"User with facebook logged in!");
            }
            if (self.delegate)
            {
                [_delegate facebookCallBack:YES];
            }

        }
    }];
    
}
-(void)logOutFacebook
{
	if (FBSession.activeSession)
	{
      //  [[FBSession activeSession] close];
		if ([FBSession.activeSession isOpen])
		{
			[FBSession.activeSession closeAndClearTokenInformation];
		}
	}
}

- (void)openSessionWithPublishPermissionsAllowLoginUI:(BOOL)allowLoginUI
{
 	NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",@"user_friends",@"publish_actions",nil];
	
	
    [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
         NSLog(@"permissions granted %@",FBSession.activeSession.permissions);
         if (error)
         {
             NSLog(@"error:- %@",error);
             [session closeAndClearTokenInformation];
            [self handleAuthError:error];
             if (self.delegate)
             {
                 [_delegate facebookCallBack:NO];
             }
         }
         else
         {
             if (self.delegate)
             {
                 [_delegate facebookCallBack:YES];
             }
         }
     }];
}
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
	[[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}
- (void)handleAuthError:(NSError *)error
{
	NSString *alertText;
	NSString *alertTitle;
	if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
		// Error requires people using you app to make an action outside your app to recover
		
		
		if ([[[error userInfo] objectForKey:@"FBErrorLoginFailedReason"] isEqualToString:FBErrorLoginFailedReasonSystemDisallowedWithoutErrorValue])
		{
			// Show a custom error message
			alertTitle = @"Facebook access disabled";
			alertText = @"Go to Settings > Facebook and turn ON YourAppName.";
			// You could also do any additional customizations here
			
		}
		else
		{
			alertTitle = @"Something went wrong";
			alertText = [FBErrorUtility userMessageForError:error];
		}
		
		
		[self showMessage:alertText withTitle:alertTitle];
        
		
		
	} else {
		// You need to find more information to handle the error within your app
		if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
			//The user refused to log in into your app, either ignore or...
			alertTitle = @"Login cancelled";
			alertText = @"You need to login to access this part of the app";
			[self showMessage:alertText withTitle:alertTitle];
			
		}
        else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
            // We need to handle session closures that happen outside of the app
            alertTitle = @"Session Error";
            alertText = @"Your current session is no longer valid. Please log in again.";
            [self showMessage:alertText withTitle:alertTitle];
            
        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Something went wrong";
            alertText = @"Please retry";
            [self showMessage:alertText withTitle:alertTitle];
        }
		
	}
}
@end
