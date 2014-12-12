//
//  LoginViewController.m
//  LinxApp
//
//  Created by Ramon Gilabert Llop on 8/23/14.
//  Copyright (c) 2014 The Black Box Labs. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h> 
#import "SignUpViewController.h"

#define VALIDURL (@"http://www.google.com")

@interface ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewKeys;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UILabel *labelError;
@property (strong, nonatomic) IBOutlet UIView *viewWithAllContent;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorTwitter;
@property BOOL doSegueToLocked;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.doSegueToLocked = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeColorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RevealInstantiation" object:nil];

    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - IBActions

- (IBAction)onLoginWithTwitterButtonPressed:(id)sender
{
    self.loadingIndicatorTwitter.hidden = NO;
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            self.loadingIndicatorTwitter.hidden = YES;
            return;
        } else if (user.isNew) {

            NSLog(@"User signed up and logged in with Twitter!");
            NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", [PFTwitterUtils twitter].screenName];

            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setObject:user forKey:@"userPointer"];
            [currentInstallation saveEventually:^(BOOL succeeded, NSError *error) {
                if (error) { }
            }];

            NSURL *verify = [NSURL URLWithString:requestString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
            [[PFTwitterUtils twitter] signRequest:request];
            NSURLResponse *response = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
            if (error == nil) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                user.username = [result objectForKey:@"screen_name"];
                [user setObject:[result objectForKey:@"name"] forKey:@"realName"];
                [user setObject:[result objectForKey:@"location"] forKey:@"city"];
                [user setObject:[result objectForKey:@"description"] forKey:@"description"];
                [user setObject:@"Interests" forKey:@"interests"];

                NSURL *url = [NSURL URLWithString:[result objectForKey:@"profile_image_url"]];
                NSData *dataForImage = [NSData dataWithContentsOfURL:url];
                PFFile *imageFile = [PFFile fileWithName:@"image.png" data:dataForImage];
                [user setObject:imageFile forKey:@"profileImage"];

                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {

                    } else {
                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                        [currentInstallation setObject:[PFUser currentUser] forKey: @"userPointer"];
                        [currentInstallation saveEventually:^(BOOL succeeded, NSError *error) {
                            if (error) { } else {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                self.loadingIndicatorTwitter.hidden = YES;
                            }
                        }];
                    }
                }];
            }
        } else {
            NSLog(@"User logged in with Twitter!");
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.loadingIndicatorTwitter.hidden = YES;
        }
    }];
}

- (IBAction)onLoginButtonPressed:(id)sender
{
    SignUpViewController *signUpVc = [SignUpViewController new];
    [self.navigationController pushViewController:signUpVc animated:YES];
    
//    [self.loadingIndicator setHidden:NO];
//    NSString *username = [self.textFieldUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSString *password = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//
//    if ([username length] == 0 || [password length] == 0) {
//        [self performAnimation];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a valid username, and password!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//        [self.loadingIndicator setHidden:YES];
//    } else {
//        [PFUser logInWithUsernameInBackground:username password:password
//                                        block:^(PFUser *user, NSError *error) {
//                                            if (user)
//                                            {
//                                                [self.navigationController popToRootViewControllerAnimated:YES];
//                                                [self.loadingIndicator setHidden:YES];
//                                            }
//                                            else
//                                            {
//                                                [self performAnimation];
//                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[[error.userInfo objectForKey:@"error"] capitalizedString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                                                [alertView show];
//                                                [self.loadingIndicator setHidden:YES];
//                                            }
//                                        }];
//    }
}

#pragma mark - Helper methods

- (void)performAnimation
{
    [UIView animateWithDuration:0.1 animations:^{
        self.buttonLogin.transform = CGAffineTransformMakeTranslation(10, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.buttonLogin.transform = CGAffineTransformMakeTranslation(-10, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.buttonLogin.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
        }];
    }];

    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:0 animations:^{
        [self.labelError setHidden:NO];
        [self.viewWithAllContent setFrame:CGRectMake(self.viewWithAllContent.frame.origin.x, self.viewWithAllContent.frame.origin.y, self.viewWithAllContent.frame.size.width, 350)];
    } completion:^(BOOL finished) { }];
}

#pragma mark - Text field

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.textFieldUsername]) {
        self.imageViewProfile.image = [UIImage imageNamed:@"highlight-username-field"];
    } else if ([textField isEqual:self.textFieldPassword]) {
        self.imageViewKeys.image = [UIImage imageNamed:@"highlight-password-field"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.imageViewKeys.image = [UIImage imageNamed:@"key L"];
    self.imageViewProfile.image = [UIImage imageNamed:@"user L"];
}

- (IBAction)usernameTextfield:(id)sender
{
    if (self.textFieldUsername.text.length > 20) {
        [self.imageViewProfile setHidden:YES];
    } else {
        [self.imageViewProfile setHidden:NO];
    }
}

- (IBAction)passwordTextField:(id)sender
{
    if (self.textFieldPassword.text.length > 15) {
        [self.imageViewKeys setHidden:YES];
    } else {
        [self.imageViewKeys setHidden:NO];
    }
}

#pragma mark - Segue methods

- (IBAction)unwindBackToLogin:(UIStoryboardPopoverSegue *)sender { }

- (IBAction)unwindBackToLoginWhenDoneIsPressed:(UIStoryboardPopoverSegue *)sender { }

- (IBAction)unwindBackToLoginFromProfile:(UIStoryboardPopoverSegue *)sender { }


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

@end
