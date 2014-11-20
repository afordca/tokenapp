//
//  LoginViewController.m
//  Token
//
//  Created by Dave on 10/16/14.
//  Copyright (c) 2014 Black Box Creative. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "SignUpTableViewController.h"
#import "LoginTableViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize markImageView, logoImageView, loginButton, signUpButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    
    // If height is 667, then we're on an iPhone 6. Thus we use the iphone 6 splash image
    // For the background view
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self determineLayout];
    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)presentSignUpViewController
{
     // present alert view letting them know the signup view controller is coming soon
    // [[[UIAlertView alloc] initWithTitle:@"SIGN UP COMING SOON" message:@"This button will be responsible for presenting a sign up screen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    SignUpTableViewController *signUpTVC = [[SignUpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *signUpNavController = [[UINavigationController alloc] initWithRootViewController:signUpTVC];
    [self presentViewController:signUpNavController animated:YES completion:nil];

}

- (void)presentLoginViewController
{
    // [[[UIAlertView alloc] initWithTitle:@"LOGIN COMING SOON" message:@"This button will be responsible for presenting a login screen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    LoginTableViewController *loginTVC = [[LoginTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginTVC];
    [self presentViewController:loginNavController animated:YES completion:nil];
}

- (void)determineLayout
{
    // If height is 667, then we're on an iPhone 6. Thus we use the iphone 6 splash image
    // for the background view
    
    if (IS_IPHONE_6_DEVICE) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Splash-iphone6"]];
        NSLog(@"On an iPhone 6");
        
        // Creating image view that will hold mark Image
        // MarkImageView is on hold for time being
        // markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(147.5, 35, 80, 80)];
        // [markImageView setImage:[UIImage imageNamed:@"Mark"]];
        
        // Creating image view that will hold token logo
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(37.5, 140, 300, 76)];
        [logoImageView setImage:[UIImage imageNamed:@"Logo"]];
        
        // Creating login button
        loginButton = [[UIButton alloc] initWithFrame:CGRectMake(37.5, 585, 300, 40)];
        
        // Creating sign up button
        signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(37.5, 535, 300, 40)];
        
        // Setting the button title to SIGN UP
        [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
        
        // Setting the button title to LOGIN
        [loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
        
      /*** Since the launch of iOS 7 (I think), buttons have come default without a border and when you set a border by setting UIButtonType property, the closest thing that you get to a rectangle border is a rounded rectangle. To get the plain rectangle border on a button, we use the following.           *****************Ya****Dig*/
        
        signUpButton.layer.cornerRadius = 2;
        signUpButton.layer.borderWidth = 1;
        signUpButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        signUpButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        loginButton.layer.cornerRadius = 2;
        loginButton.layer.borderWidth = 1;
        loginButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        //loginButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        [signUpButton addTarget:self action:@selector(presentSignUpViewController) forControlEvents:UIControlEventTouchDown];
        
        // Adding Views to launch View Controller
        [self.view addSubview:logoImageView];
        [self.view addSubview:signUpButton];
        [self.view addSubview:loginButton];
    }
    
    // If height is 568, then we're on an iPhone 5(s). Thus we use the iphone 5 splash image
    // for the background view
    
    if (IS_IPHONE_5_DEVICE) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Splash-iphone5"]];
        
        // Creating image view that will hold mark Image
        // MarkImageView is on hold for time being
        // markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(147.5, 35, 80, 80)];
        // [markImageView setImage:[UIImage imageNamed:@"Mark"]];
        
        // Creating image view that will hold token logo
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 110, 270, 76)];
        [logoImageView setImage:[UIImage imageNamed:@"Logo"]];
        
        signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 448, 250, 40)];
        loginButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 498, 250, 40)];
        
        // Setting the button title to SIGN UP
        [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
        
        // Setting the button title to LOGIN
        [loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
        
        /*** Since the launch of iOS 7 (I think), buttons have come default without a border and when you set a border by setting UIButtonType property, the closest thing that you get to a rectangle border is a rounded rectangle. To get the plain rectangle border on a button, we use the following.           *****************Ya****Dig*/
        
        signUpButton.layer.cornerRadius = 2;
        signUpButton.layer.borderWidth = 1;
        signUpButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        signUpButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        loginButton.layer.cornerRadius = 2;
        loginButton.layer.borderWidth = 1;
        loginButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        //loginButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        [signUpButton addTarget:self action:@selector(presentSignUpViewController) forControlEvents:UIControlEventTouchDown];
        
        // Adding Views to launch View Controller
        [self.view addSubview:logoImageView];
        [self.view addSubview:signUpButton];
        [self.view addSubview:loginButton];
    }
    
    // If height is 480, then we're on an iPhone 4s. Thus we use the iphone 4s splash image
    // for the background view
    
    if (IS_IPHONE_4S_DEVICE) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Splash-iphone4s"]];
        
        // markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 35, 80, 80)];
        // [markImageView setImage:[UIImage imageNamed:@"Mark"]];
        
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 110, 270, 76)];
        [logoImageView setImage:[UIImage imageNamed:@"Logo"]];
        
        signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 348, 250, 40)];
        loginButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 398, 250, 40)];
        
        loginButton.layer.cornerRadius = 2;
        loginButton.layer.borderWidth = 1;
        loginButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        
        signUpButton.layer.cornerRadius = 2;
        signUpButton.layer.borderWidth = 1;
        signUpButton.layer.borderColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0].CGColor;
        signUpButton.backgroundColor = [UIColor colorWithRed:0.4549 green:0.717647 blue:0.290196 alpha:1.0];
        
        // Setting the button title to SIGN UP
        [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
        
        // Setting the button title to LOGIN
        [loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
        
        //[self.view addSubview:markImageView];
        
        
        [self.view addSubview:logoImageView];
        [self.view addSubview:signUpButton];
        [self.view addSubview:loginButton];
    }
    
    [signUpButton addTarget:self action:@selector(presentSignUpViewController) forControlEvents:UIControlEventTouchDown];
    
    [loginButton addTarget:self action:@selector(presentLoginViewController) forControlEvents:UIControlEventTouchDown];
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
