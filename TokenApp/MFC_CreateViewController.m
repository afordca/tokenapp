//
//  MFC_CreateViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/3/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_CreateViewController.h"
#import "CamerOverlay.h"
#import "TK_DescriptionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480


@interface MFC_CreateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;

@end

@implementation MFC_CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];

}


#pragma mark - User Interface

-(void)setUI
{
    // Creating Blurred Effect background

    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

    visualEffectView.frame = self.imageViewBackground.bounds;
    [self.imageViewBackground addSubview:visualEffectView];


    //UIImagePicker Setup

    //create an overlay view instance
    CamerOverlay *overlay = [[CamerOverlay alloc]
                            initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];

    self.imagePicker = [UIImagePickerController new];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;


    //hide all controls
    self.imagePicker.showsCameraControls = YES;
    self.imagePicker.navigationBarHidden = YES;
    self.imagePicker.toolbarHidden = YES;

    self.imagePicker.cameraViewTransform =
    CGAffineTransformScale(self.imagePicker.cameraViewTransform,
                           CAMERA_TRANSFORM_X,
                           CAMERA_TRANSFORM_Y);

    //set our custom overlay view
    //self.imagePicker.cameraOverlayView = overlay;

}

#pragma mark - Button Methods

- (IBAction)buttonPressCamera:(id)sender
{
    self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self presentViewController:self.imagePicker animated:NO completion:nil];

}

- (IBAction)buttonPressVideo:(id)sender
{
    self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    [self presentViewController:self.imagePicker animated:NO completion:nil];

}

- (IBAction)buttonPressWrite:(id)sender
{

}

- (IBAction)buttonPressLink:(id)sender
{

}

//IBAction (for switching between front and rear camera).

-(IBAction)onClickButtonCamReverse:(id)sender
{
    if(self.imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else
    {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
}


#pragma mark - UIImagePicker Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    // Check if photo

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.imageCreatePhoto = [info objectForKey:UIImagePickerControllerOriginalImage];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(self.imageCreatePhoto, nil, nil, nil);

        }
    }
    // Check if Video

    else if ([mediaType isEqualToString:@"public.movie"])
    {
        self.videoURL = info[UIImagePickerControllerMediaURL];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            // Saving the video / // Get the new unique filename
            NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath];
            UISaveVideoAtPathToSavedPhotosAlbum(sourcePath,nil,nil,nil);

        }
    }

    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"pushToDescription" sender:self];
    }];




}



@end
