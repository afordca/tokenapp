//
//  SettingsViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 3/4/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Button Press Methods

- (IBAction)onButtonPressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onButtonPressSave:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
