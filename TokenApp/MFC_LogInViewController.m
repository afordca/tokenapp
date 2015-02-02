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
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

#define VALIDURL (@"http://www.google.com")

@interface MFC_LogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldLogInUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLogInPassword;

@property NSArray *permissions;


@end

@implementation MFC_LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];


    self.permissions = @[@"public_profile", @"email"];
}

- (IBAction)logOn:(id)sender
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
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:user forKey:@"user"];
                [currentInstallation saveInBackground];
                // We add a delay of two seconds to help Parse loading the stuff.
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self performSegueWithIdentifier:@"goToSwap" sender:nil];
                });
                [self setupUserProfile];
            }
        }];
    }
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

- (IBAction)faceBookLogin:(id)sender
{
    NSURL *url = [NSURL URLWithString:VALIDURL];


    if (![self isValidURL:url]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Your network connection is weak, wait until you have a better internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [PFFacebookUtils logInWithPermissions:self.permissions block:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
                // Here we'll create the user with all the stuff.

                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // I save the ID because it's unique in terms of our app, if you save the name or last name, it's not.

                        user.username = [result objectForKey:@"first_name"];
                        user.email = [result objectForKey:@"email"];

                        [user setObject: [result objectForKey:@"first_name"] forKey:@"username"];
                        [user setObject:[NSNumber numberWithInt:50] forKey:@"numberOfMiles"];

                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                        [currentInstallation setObject:user forKey:@"user"];
                        [currentInstallation saveInBackground];

                        NSString *stringWithFacebookURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result objectForKey:@"id"]];
                        NSURL *url = [NSURL URLWithString:stringWithFacebookURL];
                        NSData *dataForImage = [NSData dataWithContentsOfURL:url];
                        PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:dataForImage];
                        [user setObject:imageFile forKey:@"profileImage"];

                        // We use save eventually because, if you don't have internet connection, it's going to save it later.
                        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (error) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:[NSString stringWithFormat:@"There's an error: %@", [error userInfo]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alertView show];
                            } else {
                                [self performSegueWithIdentifier:@"goToSwap" sender:nil];
                            }
                        }];
                    }
                }];
            } else {
                NSLog(@"User logged in through Facebook!");
                [self performSegueWithIdentifier:@"goToSwap" sender:nil];
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
                    [self performSegueWithIdentifier:@"goToSwap" sender:nil];
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