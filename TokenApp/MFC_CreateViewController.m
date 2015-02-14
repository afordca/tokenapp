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
#import "TK_PostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568


@interface MFC_CreateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;

@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;

@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;


@property BOOL isVideo;

@end

@implementation MFC_CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setUpCamera];

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

}

-(void)setUpCamera
{
    //UIImagePicker Setup

    self.isVideo = NO;

    //create an overlay view instance
    CamerOverlay *overlay = [[CamerOverlay alloc]
                             initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
    overlay.delegate = self;

    self.imagePicker = [UIImagePickerController new];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;

    self.flashMode = UIImagePickerControllerCameraFlashModeAuto;
    self.imagePicker.cameraFlashMode = self.flashMode;

    //hide all controls
    self.imagePicker.showsCameraControls = NO;
    self.imagePicker.navigationBarHidden = YES;
    self.imagePicker.toolbarHidden = YES;

    self.imagePicker.cameraViewTransform =
    CGAffineTransformScale(self.imagePicker.cameraViewTransform,
                           CAMERA_TRANSFORM_X,
                           CAMERA_TRANSFORM_Y);

    //set our custom overlay view
    self.imagePicker.cameraOverlayView = overlay;

}

#pragma mark - Button Methods

- (IBAction)buttonPressCamera:(id)sender
{
    self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self presentViewController:self.imagePicker animated:NO completion:nil];

}

- (IBAction)buttonPressVideo:(id)sender
{
    self.isVideo = YES;
    self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    self.imagePicker.videoMaximumDuration = 20; //seconds
    [self presentViewController:self.imagePicker animated:NO completion:nil];

}

- (IBAction)buttonPressWrite:(id)sender
{

}

- (IBAction)buttonPressLink:(id)sender
{

}

#pragma mark - CameraOverlay Delegate Methods

-(void)onClickCameraLibrary
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];

}

//IBAction (for switching between front and rear camera).
-(void)onClickCameraReverse:(NSString *)customClass
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

-(void)onClickCameraCapturePhoto
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

    if (self.isVideo)
    {
        [self.imagePicker startVideoCapture];
    }
    else
    {
        [self.imagePicker takePicture];
    }

}

-(void)onClickCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)onClickFlashMode
{
    if (self.flashMode == UIImagePickerControllerCameraFlashModeAuto) {
        //toggle your button to "on"
        self.flashMode = UIImagePickerControllerCameraFlashModeOn;
    }else if (self.flashMode == UIImagePickerControllerCameraFlashModeOn){
        //toggle your button to "Off"
        self.flashMode = UIImagePickerControllerCameraFlashModeOff;
    }else if (self.flashMode == UIImagePickerControllerCameraFlashModeOff){
        //toggle your button to "Auto"
        self.flashMode = UIImagePickerControllerCameraFlashModeAuto;
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

        // Pictures taken from camera shot are stored to device
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //Save to Photos Album
            UIImageWriteToSavedPhotosAlbum(self.imageCreatePhoto, nil, nil, nil);

        }

        [self performSegueWithIdentifier:@"pushToDescription" sender:self];

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
            [self performSegueWithIdentifier:@"pushToDescription" sender:self];


        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self setUpCamera];
     self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
     [self dismissViewControllerAnimated:YES completion:^{
         [self presentViewController:self.imagePicker animated:NO completion:nil];

     }];
}

#pragma mark - Prepare Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier  isEqual: @"pushToDescription"])
    {
        TK_DescriptionViewController *tkDescriptionViewController = [segue destinationViewController];
        tkDescriptionViewController.imagePhoto = self.imageCreatePhoto;
        tkDescriptionViewController.urlVideo = self.videoURL;
        tkDescriptionViewController.isVideo = self.isVideo;
    }


}


@end