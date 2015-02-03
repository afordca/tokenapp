//
//  LaunchPageViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/1/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "LaunchPageViewController.h"

@interface LaunchPageViewController ()

@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;


@end

@implementation LaunchPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setHidden:YES];

    // Setup LoginButton Appearance
    CALayer *layer = self.buttonLogin.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 1.0f;

}



#pragma mark - Segue methods

- (IBAction)unwindToLoginViewControllerFromPassword:(UIStoryboardPopoverSegue *)sender { }


@end
