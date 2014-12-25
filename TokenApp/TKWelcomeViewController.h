//
//  TKWelcomeViewController.h
//  TokenApp
//
//  Created by BASEL FARAG on 12/24/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "LoginViewController.h"


@interface TKWelcomeViewController : UIViewController <LoginViewControllerDelegate>

-(void)presentLoginViewController:(BOOL)animated;

@end
