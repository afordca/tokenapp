//
//  SignUpViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/12/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "Macros.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRepeatPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBirthday;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGender;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(45, 30, 200, 40)];
    tf.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    tf.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    tf.backgroundColor=[UIColor whiteColor];
    tf.text=@"Hello World";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)uponCreateAccountButtonPressed:(id)sender {
    PFUser *user = [PFUser user];

    //First create an NSString to store the user info, and then trim it of any possible
    //white lines or spaces.
    NSString *username = self.textFieldUsername.text;
    [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.textFieldPassword.text;
    [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = self.textFieldEmail.text;
    [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    user.username = username;
    user.password = password;
    user.email = email;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            //
        } else{
            NSString *errorString = [error userInfo][@"error"];
        }
    }];
    //You need to indicate to the user you've successfully signed them up.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
