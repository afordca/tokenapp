//
//  TK_LinkViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/12/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_LinkViewController.h"
#import "TK_DescriptionViewController.h"

@interface TK_LinkViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textFieldLink;
@property BOOL isLink;

@end

@implementation TK_LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldLink.delegate = self;
    self.isLink = YES;
}

#pragma mark - Button Methods

- (IBAction)onButtonCancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onButtonNext:(id)sender
{
    NSLog(@"TEST: NEXT");
    if (![self.textFieldLink.text isEqualToString:@""])
    {
        [self performSegueWithIdentifier:@"pushToDescription" sender:nil];
    }
}

#pragma mark - UITextfield Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}

// Clicking off any controls will close the keypad

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TK_DescriptionViewController *tk_DescriptionVC =[segue destinationViewController];
    tk_DescriptionVC.stringLink = self.textFieldLink.text;
    tk_DescriptionVC.isLink = self.isLink;
}
@end
