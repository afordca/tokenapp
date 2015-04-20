//
//  SettingsViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/4/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UITextFieldDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewUserInfo;


@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property (strong, nonatomic) IBOutlet UITextField *textFieldFirstname;
@property (strong, nonatomic) IBOutlet UITextField *textFieldLastname;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldBiography;

@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (strong, nonatomic) IBOutlet UITextField *textFieldGender;
@property (strong, nonatomic) IBOutlet UITextField *textFieldBirthday;

@property (strong, nonatomic) IBOutlet UISwitch *switchPostPrivate;
@property (strong, nonatomic) IBOutlet UISwitch *switchTokensPrivate;

@property (strong,nonatomic) PFUser *currentUserUpdate;


@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Accessing User Singleton
    currentUser = [CurrentUser sharedSingleton];
    self.currentUserUpdate = [PFUser currentUser];


    [self loadUserInfo];
}

-(void)loadUserInfo
{


    self.textFieldFirstname.text = currentUser.Firstname;
    self.textFieldLastname.text = currentUser.Lastname;
    self.textFieldUsername.text = currentUser.userName;
    self.textFieldBiography.text = currentUser.Biography;

    self.textFieldEmail.text = currentUser.Email;
    self.textFieldPhone.text = currentUser.Phone;
    self.textFieldGender.text = currentUser.Gender;
    self.textFieldBirthday.text = currentUser.Birthday;

    self.switchPostPrivate.on = currentUser.switchPostPrivate;
    self.switchTokensPrivate.on = currentUser.switchTokensPrivate;

    self.imageViewProfilePic.image = currentUser.profileImage;
}

#pragma mark - Button Press Methods

- (IBAction)onButtonPressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onButtonPressSave:(id)sender
{
    self.currentUserUpdate.username = self.textFieldUsername.text;
    self.currentUserUpdate.email = self.textFieldEmail.text;
    [self.currentUserUpdate setObject:self.textFieldFirstname.text forKey:@"Firstname"];
    [self.currentUserUpdate setObject:self.textFieldLastname.text forKey:@"Lastname"];
    [self.currentUserUpdate setObject:self.textFieldBiography.text forKey:@"Biography"];
    [self.currentUserUpdate setObject:self.textFieldPhone.text forKey:@"Phone"];
    [self.currentUserUpdate setObject:self.textFieldBirthday.text forKey:@"Birthday"];
    [self.currentUserUpdate setObject:self.textFieldGender.text forKey:@"Gender"];

    [self.currentUserUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (error)
        {
            NSLog(@"Error:%@",[error userInfo]);
        }
        else
        {
            currentUser.Firstname = self.textFieldFirstname.text;
            currentUser.Lastname = self.textFieldLastname.text;
            currentUser.userName = self.textFieldUsername.text;
            currentUser.Biography = self.textFieldBiography.text;

            currentUser.Email = self.textFieldEmail.text;
            currentUser.Phone = self.textFieldPhone.text;
            currentUser.Gender = self.textFieldGender.text;
            currentUser.Birthday = self.textFieldBirthday.text;

//            currentUser.switchPostPrivate;
//            currentUser.switchTokensPrivate;

        [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];


}


#pragma mark - UITextField Delegate Methods

// The return button will close the keypad

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
    
}

// Clicking off any controls will close the keypad

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
