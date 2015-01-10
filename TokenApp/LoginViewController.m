//
//  SignUpViewController.m
//  TokenApp
//
//  Created by Basel Farag on 12/1/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import "Macros.h"
#import "ProfilePersonalViewController.h"
#import "TKTabBarController.h"
#import "ProfilePersonalViewController.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface LoginViewController () {
    FBLoginView *_facebookLoginView;
}

@property (nonatomic, strong) MBProgressHUD *hud;

@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldRepeatPassword;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewUsername;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPassword;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewRepeatPassword;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
        // for the iPhone 5
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin-568h.png"]];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]];
    }

    CGFloat yPosition = 360.0f;
    if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
        yPosition = 450.0f;
    }

    _facebookLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends", @"email", @"user_photos"]];
    _facebookLoginView.frame = CGRectMake(36.0f, yPosition, 244.0f, 44.0f);
    _facebookLoginView.delegate = self;
    _facebookLoginView.tooltipBehavior = FBLoginViewTooltipBehaviorDisable;
    [self.view addSubview:_facebookLoginView];


}

#pragma mark - Text field methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.textFieldUsername]) {
        self.imageViewUsername.image = [UIImage imageNamed:@"highlight-username-field"];
    } else if ([textField isEqual:self.textFieldEmail]) {
        self.imageViewEmail.image = [UIImage imageNamed:@"highlight-email-field"];
    } else if ([textField isEqual:self.textFieldPassword]) {
        self.imageViewPassword.image = [UIImage imageNamed:@"highlight-password-field"];
    } else if ([textField isEqual:self.textFieldRepeatPassword]) {
        self.imageViewRepeatPassword.image = [UIImage imageNamed:@"highlight-password-field"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [self handleFacebookSession];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    [self handleLogInError:error];
}

- (void)handleFacebookSession {
    if ([PFUser currentUser]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(logInViewControllerDidLogUserIn)]) {
            [self.delegate performSelector:@selector(logInViewController:DidLogUserIn:) withObject:[PFUser currentUser]];
        }
        return;
    }

    NSString *accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSDate *expirationDate = [[[FBSession activeSession] accessTokenData] expirationDate];
    NSString *facebookUserId = [[[FBSession activeSession] accessTokenData] userID];

    if (!accessToken || !facebookUserId) {
        NSLog(@"Login failure. FB Access Token or user ID does not exist");
        return;
    }

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // Unfortunately there are some issues with accessing the session provided from FBLoginView with the Parse SDK's (thread affinity)
    // Just work around this by setting the session to nil, since the relevant values will be discarded anyway when linking with Parse (permissions flag on FBAccessTokenData)
    // that we need to get back again with a refresh of the session
    if ([[FBSession activeSession] respondsToSelector:@selector(clearAffinitizedThread)]) {
        [[FBSession activeSession] performSelector:@selector(clearAffinitizedThread)];
    }

    [PFFacebookUtils logInWithFacebookId:facebookUserId
                             accessToken:accessToken
                          expirationDate:expirationDate
                                   block:^(PFUser *user, NSError *error) {

                                       if (!error) {
                                           [self.hud removeFromSuperview];
                                           if (self.delegate) {
                                               if ([self.delegate respondsToSelector:@selector(logInViewControllerDidLogUserIn:)]) {
                                                   [self.delegate performSelector:@selector(logInViewControllerDidLogUserIn:) withObject:user];
                                               }
                                           }
                                       } else {
                                           [self cancelLogIn:error];
                                       }
                                   }];
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.imageViewUsername.image = [UIImage imageNamed:@"user L"];
    self.imageViewEmail.image = [UIImage imageNamed:@"mail L"];
    self.imageViewPassword.image = [UIImage imageNamed:@"key L"];
    self.imageViewRepeatPassword.image = [UIImage imageNamed:@"key L"];
}

- (IBAction)usernameTextField:(id)sender
{
    if (self.textFieldUsername.text.length > 17) {
        [self.imageViewUsername setHidden:YES];
    } else {
        [self.imageViewUsername setHidden:NO];
    }
}

- (IBAction)emailTextField:(id)sender
{
    if (self.textFieldEmail.text.length > 18) {
        [self.imageViewEmail setHidden:YES];
    } else {
        [self.imageViewEmail setHidden:NO];
    }
}

- (IBAction)passwordTextField:(id)sender
{
    if (self.textFieldPassword.text.length > 15) {
        [self.imageViewPassword setHidden:YES];
    } else {
        [self.imageViewPassword setHidden:NO];
    }
}

- (IBAction)repeatPasswordTextField:(id)sender
{
    if (self.textFieldRepeatPassword.text.length > 15) {
        [self.imageViewRepeatPassword setHidden:YES];
    } else {
        [self.imageViewRepeatPassword setHidden:NO];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Go to the next screen
    //Check if password is correct
    NSString *username = [self.textFieldUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([username length] == 0 || [password length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a valid username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        //Set loading indicator here.
    }
    else {
        [PFUser logInWithUsernameInBackground:username password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (user)
                                            {

                                                ProfilePersonalViewController *pVC = [ProfilePersonalViewController new];
                                                [self.navigationController pushViewController:pVC animated:YES];
                                            }
                                            else
                                            {
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[[error.userInfo objectForKey:@"error"] capitalizedString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alertView show];
                                            }
                                        }];
    }


    return YES;
}


- (IBAction)uponLoginButtonPressed:(id)sender {
    //Go to the next screen
    //Check if password is correct
    NSString *username = [self.textFieldUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([username length] == 0 || [password length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a valid username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        //Set loading indicator here.
    }
    else {
        [PFUser logInWithUsernameInBackground:username password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (user)
                                            {
//                                                if (![[user objectForKey:@"emailVerified"] boolValue]){
//                                                    //Refresh to make sure the user did not recently verify
//                                                    [user fetch];
//                                                    if (![[user objectForKey:@"emailVerified"]boolValue]){
//                                                        UIAlertView *redirectAlertView = [[UIAlertView alloc]initWithTitle:@"Uh oh" message:@"You must verify your email to proceed."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                                                        [redirectAlertView show];
//                                                    }
                                            //}

                                            }
                                            else
                                            {
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[[error.userInfo objectForKey:@"error"] capitalizedString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alertView show];
                                            }
                                        }];
    }
    
    
}

#pragma mark - ()

- (void)cancelLogIn:(NSError *)error {

    if (error) {
        [self handleLogInError:error];
    }

    [self.hud removeFromSuperview];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [PFUser logOut];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentLoginViewController:NO];
}

- (void)handleLogInError:(NSError *)error {
    if (error) {
        NSLog(@"Error: %@", [[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"]);
        NSString *title = NSLocalizedString(@"Login Error", @"Login error title in PAPLogInViewController");
        NSString *message = NSLocalizedString(@"Something went wrong. Please try again.", @"Login error message in PAPLogInViewController");

        if ([[[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"] isEqualToString:@"com.facebook.sdk:UserLoginCancelled"]) {
            return;
        }

        if (error.code == kPFErrorFacebookInvalidSession) {
            NSLog(@"Invalid session, logging out.");
            [[FBSession activeSession] closeAndClearTokenInformation];
            return;
        }

        if (error.code == kPFErrorConnectionFailed) {
            NSString *ok = NSLocalizedString(@"OK", @"OK");
            NSString *title = NSLocalizedString(@"Offline Error", @"Offline Error");
            NSString *message = NSLocalizedString(@"Something went wrong. Please try again.", @"Offline message");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:ok, nil];
            [alert show];

            return;
        }

        NSString *ok = NSLocalizedString(@"OK", @"OK");

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:ok, nil];
        [alertView show];
    }
}


@end
