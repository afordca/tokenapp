//
//  TK_PostViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/12/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "TK_PostViewController.h"
#import "TK_DescriptionViewController.h"

@interface TK_PostViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textViewPost;
@property (strong, nonatomic) IBOutlet UIButton *buttonNext;
@property BOOL isPost;

@end

@implementation TK_PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.textViewPost.delegate = self;
    [self.textViewPost becomeFirstResponder];
    self.isPost = YES;



}

#pragma mark - Button Methods

- (IBAction)onButtonCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onButtonNext:(id)sender
{
    NSLog(@"TEST: NEXT");
    if (![self.textViewPost.text isEqualToString:@""])
    {
        [self performSegueWithIdentifier:@"PushToDescription" sender:nil];
    }
}

#pragma mark - TextView Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //Clear TextView
    textView.text = @"";

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
        else {
            return NO;
        }
    }
    else if([[textView text] length] > 200 )
    {
        return NO;
    }
    return YES;
}


// Clicking off any controls will close the keypad

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TK_DescriptionViewController *tk_DescriptionVC = [segue destinationViewController];
    tk_DescriptionVC.stringPost = self.textViewPost.text;
    tk_DescriptionVC.isPost = self.isPost;
}
@end
