//
//  MFC_ProfileViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/2/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_ProfileViewController.h"
#import "TK_DescriptionViewController.h"
#import "UIViewController+Camera.h"
#import "TK_LinkViewController.h"
#import "TK_PostViewController.h"
#import "CamerOverlay.h"
#import "ProfileCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568


@interface MFC_ProfileViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property CGPoint location;

// Create Main View
@property UIVisualEffectView *visualEffectView;
@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@property BOOL isVideo;


@end

@implementation MFC_ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver];

    [self.navigationController.navigationBar setHidden:YES];
    self.collectionViewProfile.delegate = self;

    //Accessing User Singleton
    currentUser = [User sharedSingleton];

    self.labelUserName.text = currentUser.userName;
    if (currentUser.profileImage)
    {
         self.imageViewProfilePic.image = currentUser.profileImage;
    }

}

#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return currentUser.arrayOfPhotos.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellProfile" forIndexPath:indexPath];

    PFObject *image = currentUser.arrayOfPhotos[indexPath.row];
    PFFile *parseFileWithImage = [image objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:parseFileWithImage.url];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (connectionError)
        {
            NSLog(@"%@",[connectionError userInfo]);
        }
        else
        {
            cell.imageViewProfileContent.image = [UIImage imageWithData:data];
        }
    }];

    return cell;
}

#pragma mark Tap Gesture Method

- (IBAction)tapProfilePic:(UITapGestureRecognizer *)tapGestureRecognizer
{
     self.location = [tapGestureRecognizer locationInView:self.view];

     if (CGRectContainsPoint(self.imageViewProfilePic.frame, self.location))
     {
         NSLog(@"Tap");
         UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing", nil];

         [actionSheet showInView:self.view];
     }
}

#pragma mark UIAction Sheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];

        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIColor *backgroundColor = [UIColor colorWithRed:0.38 green:0.51 blue:0.85 alpha:1.0];
        self.imagePicker.navigationBar.barTintColor = backgroundColor;
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];

        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePicker Controller Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    PFUser *user = [PFUser currentUser];

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        self.imageViewProfilePic.image = [info objectForKey:UIImagePickerControllerOriginalImage];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(self.imageViewProfilePic.image, nil, nil, nil);
        }
    }

    self.imageViewProfilePic.image = [self squareImageFromImage:self.imageViewProfilePic.image scaledToSize:200];

    NSData *dataFromImage = UIImagePNGRepresentation(self.imageViewProfilePic.image);
    PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:dataFromImage];
    [user setObject:imageFile forKey:@"profileImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        } else {
            currentUser.profileImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }];

}

#pragma mark - Crop image

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {

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


@end
