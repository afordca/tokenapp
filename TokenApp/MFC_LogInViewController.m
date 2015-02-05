//
//  MFC_LogInViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_LogInViewController.h"
#import "LogInViewController.h"
#import <Parse/Parse.h>

#define VALIDURL (@"http://www.google.com")

@interface MFC_LogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldLogInUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLogInPassword;



@end

@implementation MFC_LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];


    
}


-(void)setupUserProfile
{
    PFUser *user = [PFUser currentUser];

    PFFile *parseFileWithImage = [user objectForKey:@"profileImage"];
    NSURL *profileURL = [NSURL URLWithString:parseFileWithImage.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:profileURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        singleUser = [User sharedSingleton];
        singleUser.profileImage = [UIImage imageWithData:data];
        singleUser.userName = user.username;
    }];
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
                    [self performSegueWithIdentifier:@"pushToFeed" sender:nil];
                });
                [self setupUserProfile];
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

@end