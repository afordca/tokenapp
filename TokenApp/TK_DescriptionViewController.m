//
//  TK_DescriptionViewController.m
//  
//
//  Created by Emmanuel Masangcay on 2/4/15.
//
//

#import "TK_DescriptionViewController.h"

@interface TK_DescriptionViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textViewDescriptionHashtags;

@property (strong, nonatomic) IBOutlet UITextField *textFieldTagPeople;

@property (strong, nonatomic) IBOutlet UIButton *buttonShare;


@end

@implementation TK_DescriptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
}


#pragma mark - Helper Methods

-(void)setUI
{
    // Setup LoginButton Appearance
    CALayer *layer = self.buttonShare.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    // UIColor *colorTokenGreen = [UIColor colorWithRed:119.0 green:181.0 blue:81.0 alpha:.85];
    layer.borderColor = [[UIColor greenColor]CGColor];
    layer.borderWidth = 1.0f;
}


#pragma mark - Button Press Methods

- (IBAction)buttonPressCancel:(id)sender
{
    
}

- (IBAction)buttonPressFacebook:(id)sender
{

}


- (IBAction)buttonPressShare:(id)sender
{

}


@end
