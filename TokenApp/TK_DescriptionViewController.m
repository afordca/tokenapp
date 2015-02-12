//
//  TK_DescriptionViewController.m
//  
//
//  Created by Emmanuel Masangcay on 2/4/15.
//
//

#import "TK_DescriptionViewController.h"
#import "EditPhotoViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "Macros.h"
#import "Constants.h"
#import "TKCache.h"
#import "PTKContentDetailTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>

@interface TK_DescriptionViewController () <UITextFieldDelegate,UITextViewDelegate>

//Outlets
@property (strong, nonatomic) IBOutlet UITextView *textViewDescriptionHashtags;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTagPeople;
@property (strong, nonatomic) IBOutlet UIButton *buttonShare;

// Parse
@property PFUser *currentUser;
@property PFObject *photo;
@property PFObject *video;
@property PFObject *note;
@property PFFile *photoFile;


@end

@implementation TK_DescriptionViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    [self setUI];
}



#pragma mark - Helper Methods

-(void)initialize
{
    //Setting delegates
    self.textViewDescriptionHashtags.delegate = self;
    self.textFieldTagPeople.delegate = self;


    // Setting User
    self.currentUser = [PFUser currentUser];

    if (self.isPost)
    {
        self.note = [PFObject objectWithClassName:@"Note"];
        [self.note setObject:self.stringPost forKey:@"note"];
        [self.note setObject:self.currentUser forKey:@"user"];
    }


    //For Video
   else if (self.isVideo)
    {
        // Setting Video for upload to Parse
        self.video = [PFObject objectWithClassName:@"Video"];
        NSData *dataVideo = [NSData dataWithContentsOfURL:self.urlVideo];
        PFFile *videoFile = [PFFile fileWithName:@"video" data:dataVideo];

        [self.video setObject:self.currentUser forKey:@"user"];
        [self.video setObject:videoFile forKey:@"video"];
    }
    else
    // For Photo
    {
        // Resize photo
        self.imagePhoto = [self resizeImage:self.imagePhoto scaledToSize:150];
        // Setting Photo for upload to Parse
        self.photo = [PFObject objectWithClassName:@"Photo"];
        NSData *dataPhoto = UIImagePNGRepresentation(self.imagePhoto);
        PFFile *imagePhotoFile = [PFFile fileWithName:@"photo.png" data:dataPhoto];

        [self.photo setObject:self.currentUser forKey:@"user"];
        [self.photo setObject:imagePhotoFile forKey:@"image"];

    }

}

-(void)setUI
{
    // Setup LoginButton Appearance
    CALayer *layer = self.buttonShare.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    // UIColor *colorTokenGreen = [UIColor colorWithRed:119.0 green:181.0 blue:81.0 alpha:.85];
    layer.borderColor = [[UIColor greenColor]CGColor];
    layer.borderWidth = 1.0f;
}

- (UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGFloat)newSize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;

    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);

        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);

        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }

    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);

    [image drawAtPoint:origin];

    image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}


-(void)savePhotoToParse
{
    [self.photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            NSLog(@"Photo Saved");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)saveVideoToParse
{
    [self.video saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            NSLog(@"Video Saved");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)saveNoteToParse
{
    [self.note saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            NSLog(@"Note Saved");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Button Press Methods

- (IBAction)buttonPressFacebook:(id)sender
{

}


- (IBAction)buttonPressShare:(id)sender
{
    if (self.isPost)
    {
        [self.note setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
        [self saveNoteToParse];
    }

   else if (self.isVideo)
    {
        [self.video setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
        [self saveVideoToParse];
    }
    else
    {
        [self.photo setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
        [self savePhotoToParse];
    }

}


- (IBAction)onButtonCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField and TextView Delegate methods

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

@end
