//
//  EditPhotoViewController.m
//  TokenApp
//
//  Created by BASEL FARAG on 12/16/14.
//  Copyright (c) 2014 ABaselNotBasilProduction. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "Macros.h"
#import "Constants.h"
#import "TKCache.h"
#import "PTKContentDetailTableViewController.h"


@interface EditPhotoViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;
@property PFFile *photoFile;
@property PFFile *thumbnailFile;
@property UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property UIBackgroundTaskIdentifier photoPostBackgroundTaskId;
@property (nonatomic, strong) UITextField *commentTextField;



@end


@implementation EditPhotoViewController

@synthesize photo;
@synthesize scrollView;

- (id)initWithImage:(UIImage *)aImage {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!aImage) {
            return nil;
        }

        self.image = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

-(void)loadView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.view = self.scrollView;

    UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 42.0f, 320.0f, 320.0f)];
    [photoImageView setBackgroundColor:[UIColor blackColor]];
    [photoImageView setImage:self.image];
    [photoImageView setContentMode:UIViewContentModeScaleAspectFill];
    // Do any additional setup after loading the view.

    [self.scrollView addSubview:photoImageView];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, photoImageView.frame.origin.y + photoImageView.frame.size.height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self shouldUploadImage:self.image];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doneButtonAction:textField];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.commentTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController 



//The goal here is to store two versions of the photo in order to boost the performance of the UITableViews. 

-(BOOL)shouldUploadImage:(UIImage *)anImage {
    //Resize the image to be square (or what's show in the image preview)
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationDefault];
    //Create a thumbnail and add a corner radius to it so it can more easily be used in tableview
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    //Get an NSData rep of the images. JPEG for the large image. PNG for the thumbnail to keep corner
    //radius transparency
    //JPEG to decrease the file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);

    if (!imageData || !thumbnailImageData){
        return NO;
    }
    //Create the PFFiles and store them in propertues since we'll use them later
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];

    //Request a background Execution task to allow app to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];

    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Thumbnail uploaded successfully");
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];

        }
    }];

    return YES;
}


- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height += keyboardFrameEnd.size.height;
    [self.scrollView setContentSize:scrollViewContentSize];

    CGPoint scrollViewContentOffset = self.scrollView.contentOffset;
    // Align the bottom edge of the photo with the keyboard
    scrollViewContentOffset.y = scrollViewContentOffset.y + keyboardFrameEnd.size.height*3.0f - [UIScreen mainScreen].bounds.size.height;

    [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
    [UIView animateWithDuration:0.200f animations:^{
        [self.scrollView setContentSize:scrollViewContentSize];
    }];
}


- (void)shouldDeletePhoto {
    // Delete all activites related to this photo
    PFQuery *query = [PFQuery queryWithClassName:kPTKActivityClassKey];
    [query whereKey:kPTKActivityPhotoKey equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }

        // Delete photo
        [self.photo deleteEventually];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:PTKPhotoDetailsViewControllerUserDeletedPhotoNotification object:[self.photo objectId]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonAction:(id)sender {
    //Trim the comment and save it in a dictionary for use later in a callback block.
    NSDictionary *userInfo = [NSDictionary dictionary];
    NSString *trimmedComment = [self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    trimmedComment,kPTKEditPhotoViewControllerUserInfoCommentKey,
                    nil];
    }

    //Make sure there were no errors creating the image files
    if (!self.photoFile || !self.thumbnailFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }

    // both files have finished uploading

    // create a photo object
    PFObject *photo = [PFObject objectWithClassName:kPTKPhotoClassKey];
    [photo setObject:[PFUser currentUser] forKey:kPTKPhotoUserKey];
    [photo setObject:self.photoFile forKey:kPTKPhotoPictureKey];
    [photo setObject:self.thumbnailFile forKey:kPTKPhotoThumbnailKey];

    // photos are public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    photo.ACL = photoACL;

    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];

    // save the Photo PFObject
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded");

            [[TKCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];

            // userInfo might contain any caption which might have been posted by the uploader
            if (userInfo) {
                NSString *commentText = [userInfo objectForKey:kPTKEditPhotoViewControllerUserInfoCommentKey];

                if (commentText && commentText.length != 0) {
                    // create and save photo caption
                    PFObject *comment = [PFObject objectWithClassName:kPTKActivityClassKey];
                    [comment setObject:kPTKActivityTypeComment forKey:kPTKActivityTypeKey];
                    [comment setObject:photo forKey:kPTKActivityPhotoKey];
                    [comment setObject:[PFUser currentUser] forKey:kPTKActivityFromUserKey];
                    [comment setObject:[PFUser currentUser] forKey:kPTKActivityToUserKey];
                    [comment setObject:commentText forKey:kPTKActivityContentKey];

                    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    [ACL setPublicReadAccess:YES];
                    comment.ACL = ACL;

                    [comment saveEventually];
                    [[TKCache sharedCache] incrementCommentCountForPhoto:photo];
                }
            }
            //We cal NSNotification so that the timeline viewcontroller can refresh itself when the user
            //visits the Timeline.
            [[NSNotificationCenter defaultCenter] postNotificationName:PTKTabBarControllerDidFinishEditingPhotoNotification object:photo];
        } else {
            NSLog(@"Photo failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        //Lastly we call the endBackgroundTask: method. This will suspend the application if it was
        //currently in the background or cancel the request for background processing since everything was completeted while the app was in the foreground.
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];

    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)cancelButtonAction:(id)sender
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}




@end
