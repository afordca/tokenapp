//
//  MFC_ForgotPasswordViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_ForgotPasswordViewController.h"
#import <Parse/Parse.h>

@interface MFC_ForgotPasswordViewController ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UIButton *buttonSendLink;
@property NSArray *arrayWithUsers;
@property UIAlertView *alertViewSendPassword;

@end

@implementation MFC_ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];

    PFQuery *queryOfEmails = [PFUser query];
    [queryOfEmails findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {

        } else {
            self.arrayWithUsers = objects;
        }
    }];

    self.alertViewSendPassword.delegate = self;
    self.textFieldEmail.delegate = self;

    [self.buttonSendLink setEnabled:NO];
}

#pragma mark - UITextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self.buttonSendLink setEnabled:NO];
    } else {
        [self.buttonSendLink setEnabled:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0) {
        [self.buttonSendLink setEnabled:NO];
    } else {
        [self.buttonSendLink setEnabled:YES];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

#pragma mark - IBActions

- (IBAction)onForgotPasswordButtonPressed:(id)sender
{

    int counterExistsEmail = 0;
    if (self.buttonSendLink.enabled == YES) {
        if (![self.textFieldEmail.text isEqualToString:@""] || !(self.textFieldEmail.text == nil)) {
            for (PFUser *user in self.arrayWithUsers) {
                if ([user.email isEqualToString:self.textFieldEmail.text]) {
                    [PFUser requestPasswordResetForEmailInBackground:self.textFieldEmail.text];
                    counterExistsEmail = counterExistsEmail + 1;

                    self.alertViewSendPassword = [[UIAlertView alloc] initWithTitle:@"Great" message:@"An email with the instructions has been sent." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [self.alertViewSendPassword show];

                    break;
                }
            }

            if (counterExistsEmail == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"This email address doesn't exist!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.alertViewSendPassword]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}




@end
