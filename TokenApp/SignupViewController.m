//
//  SignUpViewController.m
//  TokenApp
//
//  Created by Basel Farag on 12/1/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>


@interface SignUpViewController () <UITextFieldDelegate>

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

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - IBActions

- (IBAction)onSignUpButtonPressed:(id)sender
{
    [self.loadingIndicator setHidden:NO];
    PFUser *user = [PFUser user];

    NSString *username = [self.textFieldUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (self.textFieldUsername.text.length == 0 || self.textFieldEmail.text.length == 0 || self.textFieldPassword.text.length == 0 || self.textFieldRepeatPassword.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Something is missing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [self.loadingIndicator setHidden:YES];
    }

    else if ([self.textFieldPassword.text length] < 6)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Your password should be at least 6 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [self.loadingIndicator setHidden:YES];
        self.textFieldPassword.text = @"";
        self.textFieldRepeatPassword.text= @"";
    }

    else if (![self.textFieldPassword.text isEqualToString:self.textFieldRepeatPassword.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Your passwords have to be the same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [self.loadingIndicator setHidden:YES];
    }

    else
    {
        user.username = username;
        user.email = email;
        user.password = password;
        [user setObject:@"Change your name" forKey:@"realName"];
        [user setObject:@"Change your city" forKey:@"city"];
        [user setObject:@"First of all, swipe up and you'll find an edit your profile page, there you'll be able to edit your city, name and the description about yourself." forKey:@"description"];
        [user setObject:@"Interests" forKey:@"interests"];

        NSData *dataFromImage = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder2"]);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:dataFromImage];
        [user setObject:imageFile forKey:@"profileImage"];

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[NSString stringWithFormat: @"%@", [[error.userInfo objectForKey:@"error"] capitalizedString]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
                [self.loadingIndicator setHidden:YES];
            } else {
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:[PFUser currentUser] forKey: @"userPointer"];
                [currentInstallation saveEventually:^(BOOL succeeded, NSError *error) {
                    if (error) { }
                }];
                [self.loadingIndicator setHidden:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - Segue methods

@end
