//
//  TK_DescriptionViewController.m
//  
//
//  Created by Emmanuel Masangcay on 2/4/15.
//
//

#import "AppDelegate.h"
#import "TK_DescriptionViewController.h"
#import "MFC_HomeFeedViewController.h"
#import "EditPhotoViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "Macros.h"
#import "Constants.h"
#import "TKCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>


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
@property PFObject *link;
@property PFObject *activity;
@property PFFile *photoFile;

-(void)loadArray:(void (^)(BOOL result))completionHandler;

@end

@implementation TK_DescriptionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
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

    if (self.isLink) {
        self.link = [PFObject objectWithClassName:@"Link"];
        [self.link setObject:self.stringLink forKey:@"url"];
        [self.link setObject:self.currentUser forKey:@"user"];
        [self.link setObject:self.currentUser.objectId forKey:@"userName"];
    }

   else if (self.isPost)
    {
        self.note = [PFObject objectWithClassName:@"Note"];
        [self.note setObject:self.stringPost forKey:@"note"];
        [self.note setObject:self.currentUser forKey:@"user"];
        [self.note setObject:self.currentUser.objectId forKey:@"userName"];
    }


    //For Video
   else if (self.isVideo)
    {
        // Setting Video for upload to Parse
        NSData *fileData;
        NSString *fileName;

        fileData = [NSData dataWithContentsOfFile:self.stringVideoURL];
        fileName = @"video.mov";

        self.video = [PFObject objectWithClassName:@"Video"];
        PFFile *videoFile = [PFFile fileWithName:fileName data:fileData];


        [self.video setObject:self.currentUser forKey:@"user"];
        [self.video setObject:self.currentUser.objectId forKey:@"userName"];
        [self.video setObject:videoFile forKey:@"video"];
        [self.video setObject:self.currentUser.username forKey:@"UserName"];

        [self.activity setObject:@"post" forKey:@"type"];
        [self.activity setObject:@"video" forKey:@"mediaType"];
        [self.activity setObject:self.currentUser forKey:@"fromUser"];
        [self.activity setObject:self.photo forKey:@"photo"];
        [self.activity setObject:self.currentUser.objectId forKey:@"fromUserID"];
        [self.activity setValue:self.currentUser.username forKey:@"username"];


    }
    else
    // For Photo
    {
        // Resize photo
        self.imagePhoto = [self resizeImage:self.imagePhoto scaledToSize:150];
        // Setting Photo for upload to Parse
        self.photo = [PFObject objectWithClassName:@"Photo"];
        self.activity = [PFObject objectWithClassName:@"Activity"];
        NSData *dataPhoto = UIImagePNGRepresentation(self.imagePhoto);
        PFFile *imagePhotoFile = [PFFile fileWithName:@"photo.png" data:dataPhoto];

        [self.photo setObject:self.currentUser forKey:@"user"];
        [self.photo setObject:self.currentUser.objectId forKey:@"userName"];
        [self.photo setObject:self.currentUser.username forKey:@"UserName"];
        [self.photo setObject:imagePhotoFile forKey:@"image"];

        [self.activity setObject:@"post" forKey:@"type"];
        [self.activity setObject:@"photo" forKey:@"mediaType"];
        [self.activity setObject:self.currentUser forKey:@"fromUser"];
        [self.activity setObject:self.photo forKey:@"photo"];
        [self.activity setObject:self.currentUser.objectId forKey:@"fromUserID"];
        [self.activity setValue:self.currentUser.username forKey:@"username"];

    }

}

-(void)setUI
{

    [self.navigationController.navigationBar setHidden:YES];

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

            [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                NSLog(@"Photo Saved");
                [currentUser.arrayOfPhotos addObject:self.imagePhoto];


                        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        MFC_HomeFeedViewController *hc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeFeed"];

                        [self.navigationController pushViewController: hc animated:YES];


            }];

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
            [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 NSLog(@"Video Saved");

                 NSURL *url = [NSURL URLWithString:self.stringVideoURL];
                 Video *video = [[Video alloc]initWithUrl:url];

                 [currentUser.arrayOfVideos addObject:video];


                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 MFC_HomeFeedViewController *hc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeFeed"];

                 [self.navigationController pushViewController: hc animated:YES];
                 
                 
             }];

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
//            [self.navigationController popToRootViewControllerAnimated:YES];

            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MFC_HomeFeedViewController *hc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeFeed"];

            [self.navigationController pushViewController: hc animated:YES];
        }
    }];
}

-(void)saveLinkToParse
{
    [self.link saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
        else
        {
            NSLog(@"Link Saved");
//            [self.navigationController popToRootViewControllerAnimated:YES];

            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MFC_HomeFeedViewController *hc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeFeed"];

            [self.navigationController pushViewController: hc animated:YES];
        }
    }];
}

#pragma mark - Button Press Methods

- (IBAction)buttonPressFacebook:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {

        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        if (self.isLink)
        {
            [controller setInitialText:self.textViewDescriptionHashtags.text];
            NSURL *linkURL = [NSURL URLWithString:self.stringLink];
            [controller addURL:linkURL];
            [self presentViewController:controller animated:YES completion:nil];

            [self.link setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
            [self saveLinkToParse];
        }

        if (self.isPost)
        {
            [controller setInitialText:self.stringPost];
            [self presentViewController:controller animated:YES completion:nil];

            [self.note setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
            [self saveNoteToParse];
        }

        else if (self.isVideo)
        {



        }


        else
        {
            [controller setInitialText:self.textViewDescriptionHashtags.text];
            [controller addImage:self.imagePhoto];
            [self presentViewController:controller animated:YES completion:nil];

            [self.photo setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
            [self savePhotoToParse];
        }
        
    }

}

- (IBAction)buttonPressTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];

        if (self.isLink)
        {
            [tweetSheet setInitialText:self.textViewDescriptionHashtags.text];
            NSURL *linkURL = [NSURL URLWithString:self.stringLink];
            [tweetSheet addURL:linkURL];
            [self presentViewController:tweetSheet animated:YES completion:nil];

            [self.link setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
            [self saveLinkToParse];
        }

        if (self.isPost)
        {
            [tweetSheet setInitialText:self.stringPost];
            [self presentViewController:tweetSheet animated:YES completion:nil];

            [self.note setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
            [self saveNoteToParse];
        }


        // CANT POST VIDEO
        else if (self.isVideo)
        {
            [self.video setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
            [self saveVideoToParse];
        }
        else
        {
            [tweetSheet setInitialText:self.textViewDescriptionHashtags.text];
            [tweetSheet addImage:self.imagePhoto];
            [self presentViewController:tweetSheet animated:YES completion:nil];

            [self.photo setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
            [self savePhotoToParse];
        }

    }
}


- (IBAction)buttonPressShare:(id)sender
{
    if (self.isLink)
    {
        [self.link setObject:self.textViewDescriptionHashtags.text forKey:@"description"];
        [self saveLinkToParse];
    }

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
