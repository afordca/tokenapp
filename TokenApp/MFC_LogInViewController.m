//
//  MFC_LogInViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_LogInViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "Reachability.h"
#import "TKHomeViewController.h"
#import "TKWelcomeViewController.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "Constants.h"
#import "TKTabBarController.h"
#import "TKActivityFeedViewController.h"
#import "ProfilePersonalViewController.h"
#import "CreateContentViewController.h"
#import "BalanceTableViewController.h"
#import "CurrentUser.h"

#define VALIDURL (@"http://www.google.com")

@interface MFC_LogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldLogInUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLogInPassword;

@property PFUser *currentUser;
@property CurrentUser *singleUser;

@property (nonatomic, strong) void(^completionHandler)(BOOL loaded);



-(void)loadArray:(void (^)(BOOL result))completionHandler;

@end

@implementation MFC_LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
     self.currentUser = [PFUser currentUser];
    self.singleUser = [CurrentUser sharedSingleton];

}

-(void)checkUser
{


    if (self.currentUser)
    {

    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:[self.currentUser objectId] block:^(PFObject *user, NSError *error){
        if (!error) {
            // The get request succeeded. Log the score
            NSLog(@"Success, I exist so it's all good");

        } else {
            // Log details of our failure
            NSLog(@"This is the Error!: %@ %@", error, [error userInfo]);
            [PFUser logOut];
        }
    }];


    }
}

- (IBAction)newUser:(id)sender
{
    self.textFieldLogInPassword.text = nil;
    self.textFieldLogInUserName.text = nil;
}

#pragma mark - UITextField Delegate Methods

// The return button will close the keypad

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    if (![self.textFieldLogInUserName.text  isEqual: @""] && ![self.textFieldLogInPassword.text  isEqual: @""]) {

        [self login];

    };

    return YES;

}

-(void)login
{
    NSURL *url = [NSURL URLWithString:VALIDURL];

    if (![self isValidURL:url]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Your network connection is weak, wait until you have a better internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else if ([self.textFieldLogInUserName.text isEqualToString:@""] || self.textFieldLogInUserName.text == nil || [self.textFieldLogInPassword.text isEqualToString:@""] || self.textFieldLogInUserName.text == nil) {
        UIAlertView *alertViewFirst = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Username or password are blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertViewFirst show];
    } else {
        [PFUser logInWithUsernameInBackground:self.textFieldLogInUserName.text password:self.textFieldLogInPassword.text block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:[[error.userInfo objectForKey:@"error"] capitalizedString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                // We add a delay of two seconds to help Parse loading the stuff.
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

                    NSNumber *newUserNumber = [[PFUser currentUser] objectForKey: @"newuser"];
                    bool newUserBoolean = [newUserNumber boolValue];

                    if (newUserBoolean)
                    {
                        //WE CAN ADD LOGIC HERE TO HANDLE NEW USERS

//                        [self loadArray:^(BOOL result) {
//                            if (result)
                         //   {

                                [self performSegueWithIdentifier:@"pushToFeed" sender:nil];
                           // }
//                        }];

                    }
                    else
                    {
                        [self loadArray:^(BOOL result) {
                            if (result)
                            {
                                [self performSegueWithIdentifier:@"pushToFeed" sender:nil];
                            }
                        }];

                    }

                });
            }
        }];
    }

}

// Clicking off any controls will close the keypad

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)isValidURL:(NSURL *)url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *res = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err || res.statusCode == 404) {
        return false;
    }
    else
    {
        return true;
    }
}

-(IBAction)cancelSignUp:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadArray:(void (^)(BOOL))completionHandler
{


    [self.singleUser loadArrayOfFollowers:^(BOOL result)
    {
        [self.singleUser loadArrayOfFollowing:NO row:0 completion:^(BOOL result)
        {
            [self.singleUser loadHomeFeedActivity:^(BOOL result)
            {
                [self.singleUser loadHomeFeedContent:^(BOOL result)
                {
                    [self.singleUser setUserProfile];
                    completionHandler(YES);
                }];
            }];
        }];
    }];




}

@end