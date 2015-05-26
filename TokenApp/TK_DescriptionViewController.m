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
#import "Macros.h"
#import "Constants.h"
#import "TKCache.h"
#import "HomeFeedPost.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MediaPlayer.h>

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
@property PFFile *videoFile;

-(void)loadArray:(void (^)(BOOL result))completionHandler;

@end

@implementation TK_DescriptionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    currentUser = [CurrentUser sharedSingleton];
    [self initialize];
    [self setUI];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"view disappear");
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendCancel" object:self];
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

        self.imageLink = [self resizeImage:self.imageLink scaledToSize:150];

        self.link = [PFObject objectWithClassName:@"Link"];
        self.activity = [PFObject objectWithClassName:@"Activity"];
        NSData *dataLink = UIImagePNGRepresentation(self.imageLink);
        PFFile *imageLinkFile = [PFFile fileWithName:@"link.png" data:dataLink];

        [self.link setObject:self.stringLink forKey:@"url"];
        [self.link setObject:self.currentUser forKey:@"user"];
        [self.link setObject:self.currentUser.objectId forKey:@"userName"];
        [self.link setObject:self.stringLinkTitle forKey:@"linkTitle"];
        [self.link setObject:imageLinkFile forKey:@"imageLink"];


        [self.activity setObject:@"posted" forKey:@"type"];
        [self.activity setObject:@"link" forKey:@"mediaType"];
        [self.activity setObject:self.link forKey:@"link"];
        [self.activity setObject:self.currentUser forKey:@"fromUser"];
        [self.activity setObject:self.currentUser.objectId forKey:@"fromUserID"];
        [self.activity setValue:self.currentUser.username forKey:@"username"];
    }
   else if (self.isPost)
    {
        self.note = [PFObject objectWithClassName:@"Note"];
        self.activity = [PFObject objectWithClassName:@"Activity"];

        [self.note setObject:self.stringPost forKey:@"note"];
        [self.note setObject:self.currentUser forKey:@"user"];
        [self.note setObject:self.currentUser.objectId forKey:@"userName"];

        [self.activity setObject:@"posted" forKey:@"type"];
        [self.activity setObject:@"note" forKey:@"mediaType"];
        [self.activity setObject:self.currentUser forKey:@"fromUser"];
        [self.activity setObject:self.note forKey:@"note"];
        [self.activity setObject:self.currentUser.objectId forKey:@"fromUserID"];
        [self.activity setValue:self.currentUser.username forKey:@"username"];
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
        self.activity = [PFObject objectWithClassName:@"Activity"];
        self.videoFile = [PFFile fileWithName:fileName data:fileData];

        [self.video setObject:self.currentUser forKey:@"user"];
        [self.video setObject:self.currentUser.objectId forKey:@"userName"];
        [self.video setObject:self.videoFile forKey:@"video"];
        [self.video setObject:self.currentUser.username forKey:@"UserName"];

        [self.activity setObject:@"posted" forKey:@"type"];
        [self.activity setObject:@"video" forKey:@"mediaType"];
        [self.activity setObject:self.currentUser forKey:@"fromUser"];
        [self.activity setObject:self.video forKey:@"video"];
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

        [self.activity setObject:@"posted" forKey:@"type"];
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
                //Add to Activity Array
                NSString *name = currentUser.userName;
                NSString *photoID = self.photo.objectId;
                NSString *userID = currentUser.userID;
                UIImage *profilePic = currentUser.profileImage;
                UIImage *contentImage = self.imagePhoto;
                NSInteger numberOfLikes = 0;

                Photo *photo = [[Photo alloc]initWithImage:contentImage name:name time:nil description:self.description photoID:photoID likes:numberOfLikes];
                User *user = [[User alloc]initWithUser:self.currentUser];
                [currentUser.arrayOfPhotos addObject:photo];

                HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:profilePic timePosted:nil photo:photo post:nil video:nil link:nil mediaType:@"photo" userID:userID user:user];

                [currentUser.arrayOfHomeFeedContent addObject:homeFeedPost];
                currentUser.justPosted = YES;

                if (self.tabBarController.selectedIndex != 0)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabNav" object:self];

                }

                [[NSNotificationCenter defaultCenter] postNotificationName:@"Cancel" object:self];
                [self.navigationController popToRootViewControllerAnimated:YES];

                [self performSelector:@selector(sendNotify) withObject:nil afterDelay:0.6];
            }];
        }
    }];
}

-(void)sendNotify
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SendCancel" object:self];
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
                 //Add Video to Video Array
                 NSURL *url = [NSURL URLWithString:self.videoFile.url];

                 //Add to Activity Array
                 NSString *name = currentUser.userName;
                  NSString *userID = currentUser.userID;
                 NSString *videoID = self.video.objectId;
                 UIImage *profilePic = currentUser.profileImage;
                 NSInteger numberOfLikes = 0;

                  Video *video = [[Video alloc]initWithUrl:url likes:numberOfLikes videoID:videoID videoDescription:self.video.description];
                 User *user = [[User alloc]initWithUser:self.currentUser];
                    [currentUser.arrayOfVideos addObject:video];

                 HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:profilePic timePosted:nil photo:nil post:nil video:video link:nil mediaType:@"video" userID:userID user:user];

                 [currentUser.arrayOfHomeFeedContent addObject:homeFeedPost];

                 currentUser.justPosted = YES;

                 if (self.tabBarController.selectedIndex != 0)
                 {
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"tabNav" object:self];

                 }

                 [[NSNotificationCenter defaultCenter] postNotificationName:@"Cancel" object:self];
                 [self.navigationController popToRootViewControllerAnimated:YES];

                 [self performSelector:@selector(sendNotify) withObject:nil afterDelay:0.6];
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
            [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 NSLog(@"Note Saved");
                 //Add to Activity Array
                 NSString *name = currentUser.userName;
                  NSString *userID = currentUser.userID;
                 UIImage *profilePic = currentUser.profileImage;

                 NSString *postMessage = self.stringPost;
                 NSString *postHeader = [self.note objectForKey:@"description"];
                 NSInteger numberOfLikes = 0;

                 Post *post = [[Post alloc]initWithDescription:postMessage header:postHeader likes:numberOfLikes];
                 User *user = [[User alloc]initWithUser:self.currentUser];

                 [currentUser.arrayOfPosts addObject:post];

                 HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:profilePic timePosted:nil photo:nil post:post video:nil link:nil mediaType:@"post" userID:userID user:user];

                 [currentUser.arrayOfHomeFeedContent addObject:homeFeedPost];

                 currentUser.justPosted = YES;

                 if (self.tabBarController.selectedIndex != 0)
                 {
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"tabNav" object:self];

                 }

                 [[NSNotificationCenter defaultCenter] postNotificationName:@"Cancel" object:self];
                 [self.navigationController popToRootViewControllerAnimated:YES];

                 [self performSelector:@selector(sendNotify) withObject:nil afterDelay:0.6];
             }];
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
            [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
            NSLog(@"Link Saved");
             //Add to Activity Array
             NSString *name = currentUser.userName;
            NSString *userID = currentUser.userID;
            NSString *linkID = self.link.objectId;
            NSString *linkDescription = [self.link objectForKey:@"description"];
            NSString *linkTitle = self.stringLinkTitle;
            UIImage *profilePic = currentUser.profileImage;
            NSInteger numberOfLikes = 0;


             NSString *linkURL = self.stringLink;
             Link *link = [[Link alloc]initWithUrl:linkURL linkImage:self.imageLink linkDescription:linkDescription linkTitle:linkTitle likes:numberOfLikes linkID:linkID];
             User *user = [[User alloc]initWithUser:self.currentUser];

             [currentUser.arrayOfLinks addObject:link];

             HomeFeedPost *homeFeedPost = [[HomeFeedPost alloc]initWithUsername:name profilePic:profilePic timePosted:nil photo:nil post:nil video:nil link:link mediaType:@"link" userID:userID user:user];

              [currentUser.arrayOfHomeFeedContent addObject:homeFeedPost];

             currentUser.justPosted = YES;

             if (self.tabBarController.selectedIndex != 0)
             {
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"tabNav" object:self];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"Cancel" object:self];
             [self.navigationController popToRootViewControllerAnimated:YES];

             [self performSelector:@selector(sendNotify) withObject:nil afterDelay:0.6];
         }];
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
