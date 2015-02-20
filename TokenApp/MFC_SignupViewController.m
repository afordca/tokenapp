//
//  MFC_SignupViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_SignupViewController.h"
#import <Parse/Parse.h>

#define VALIDURL (@"http://www.google.com")

@interface MFC_SignupViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textFieldFirstname;
@property (strong, nonatomic) IBOutlet UITextField *textFieldLastname;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldConfirmEmail;

@property BOOL validate;

@end

@implementation MFC_SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    self.textFieldFirstname.delegate = self;
    self.textFieldLastname.delegate = self;
    self.textFieldUsername.delegate = self;
    self.textFieldPassword.delegate = self;
    self.textFieldEmail.delegate = self;
    self.textFieldConfirmEmail.delegate = self;

    self.validate = YES;

}

// The return button will close the keypad

#pragma mark - Text field methods


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}

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


-(IBAction)createUser:(UIButton *)sender
{

    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *textfield = (UITextField *)view;
            if (([textfield.text isEqualToString:@""]))
            {
                self.validate = NO;

                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Empty Fields" message:@"Please make sure to fill out all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                break;
            }
        }
    }

    if ([self NSStringIsValidEmail:self.textFieldEmail.text] == 0 && ![self.textFieldEmail.text  isEqual: @""])
    {
            self.validate = NO;

            UIAlertView *alertEmail = [[UIAlertView alloc]initWithTitle:@"Alert Message" message:@"Please enter a correct Email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertEmail show];

            self.textFieldEmail.text = NULL;
    }
    else if(self.validate == YES)
    {

            NSString *userName  = [self.textFieldUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *password = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *email = [self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];


        //Creating an new instance of PFUSER and then storing PFUSER properties username,password,email

        PFUser *newUser = [PFUser user];

        newUser.username = userName;
        newUser.password = password;
        newUser.email = email;
        [newUser setObject:[NSNumber numberWithBool:YES] forKey:@"newuser"];

        //Setting Singleton User
        singleUser.userName = userName;

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

                 [alertView show];
             }
             else
             {
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
         }];
    }
}

#pragma mark - Helper Methods

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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


#pragma mark - Segue methods

-(IBAction)cancelSignUp:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
