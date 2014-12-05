//
//  ResetPasswordViewController.m
//  TokenApp
//
//  Created by Basel Farag on 12/5/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>

@interface ResetPasswordViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UILabel *labelInformation;
@property (strong, nonatomic) IBOutlet UITextField *textFieldResetPassword;
@property UIAlertView *alertView;
@property BOOL hasFoundEmail;
@property BOOL shouldPerformSegue;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];

    self.alertView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.shouldPerformSegue = NO;
    self.hasFoundEmail = NO;
    self.labelInformation.text = @"In order to reset your password, enter here your e-mail.";
}

- (IBAction)onSendRequestButtonPressed:(id)sender
{
    [self.loadingIndicator setHidden:NO];

    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:[[error.userInfo objectForKey:@"error"] capitalizedString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {

            NSArray *arrayOfUsers = objects;
            for (PFUser *user in arrayOfUsers) {
                if ([user.email isEqualToString:self.textFieldResetPassword.text]) {
                    self.labelInformation.text = @"You will receive a new e-mail soon with instructions.";
                    [PFUser requestPasswordResetForEmailInBackground:self.textFieldResetPassword.text];
                    self.alertView = [[UIAlertView alloc] initWithTitle:@"Great" message:@"An e-mail has been sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [self.alertView show];
                    [self.loadingIndicator setHidden:YES];
                    self.hasFoundEmail = YES;
                    break;
                }
            }

            if (self.hasFoundEmail == NO) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"This email doesn't exist!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [self.loadingIndicator setHidden:YES];
            }
        }
    }];
}

#pragma mark - UIAlertView methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.alertView] && buttonIndex == 0) {
        self.shouldPerformSegue = YES;
        [self shouldPerformSegueWithIdentifier:@"goToLoginFromResetPassword" sender:self];
        [self performSegueWithIdentifier:@"goToLoginFromResetPassword" sender:self];
    }
}

#pragma mark - Segue methods

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"goToLoginFromResetPassword"]) {
        if (self.shouldPerformSegue) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

- (IBAction)unwindToChangePassword:(UIStoryboardPopoverSegue *)sender { }


@end
