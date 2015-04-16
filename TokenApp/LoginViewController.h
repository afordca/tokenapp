//
//  SignUpViewController.h
//  TokenApp
//
//  Created by Basel Farag on 12/1/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macros.h"
#import "Constants.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>



@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController <FBLoginViewDelegate>
{
    UIImageView *logoImageView;
    UIButton *loginButton;
    UIButton *signUpButton;
}

@property (nonatomic, assign) id<LoginViewControllerDelegate> delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>

- (void)logInViewControllerDidLogUserIn:(LoginViewController *)logInViewController;


@end

