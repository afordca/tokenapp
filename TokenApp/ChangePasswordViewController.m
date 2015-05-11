//
//  ChangePasswordViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 4/21/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <Parse/Parse.h>


@interface ChangePasswordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textFieldOldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldConfirmNewPasword;

@property PFUser *user;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.user = [PFUser currentUser];

}

#pragma mark - Button Press Methods

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    if ([self.user.password isEqual:self.textFieldOldPassword.text])
    {
        NSLog(@"Password Confirm");
    }
}


@end
