//
//  UIViewController+Camera.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/16/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "UIViewController+Camera.h"
#import "TK_DescriptionViewController.h"
#import "CamerOverlay.h"
#import "CurrentUser.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation UIViewController (Camera)

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

-(void)pushSegueToDescriptionViewController
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TK_DescriptionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Description"];
    vc.imagePhoto = self.imageCreatePhoto;
    vc.urlVideo = self.videoURL;
    vc.isVideo = self.isVideo;
    [self.navigationController pushViewController: vc animated:YES];

}

#pragma mark - Helper Methods

-(void)addObserver
{
    // Observer for when CREATE button is pressed. Presents Create Main View
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"CreateMainView"
                                               object:nil];
  
    // Observer for when CANCEL button is pressed. Removes the CreateMainView from superview
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"SendCancel"
                                               object:nil];

    // Observer for when TAKE PHOTO button is pressed. UIImagePickerController presented
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"TakePhoto"
                                               object:nil];

    // Observer for when TAKE PHOTO button is pressed. UIImagePickerController presented
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"TakeVideo"
                                               object:nil];

    // Observer for when Post Note button is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"PostNote"
                                               object:nil];

    // Observer for when Post Note button is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"PostLink"
                                               object:nil];
}

#pragma mark - Notification Methods


- (void)receivedNotification:(NSNotification *) notification {

    if ([[notification name] isEqualToString:@"CreateMainView"])
    {
        //Create blurEffect and intialize visualEffect View

        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

#warning Revisit these magic numbers!!! Add them to Constants Class

        self.visualEffectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 520);

        UIView *mainView = [[[NSBundle mainBundle] loadNibNamed:@"CreateMainView"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];

        [self.visualEffectView addSubview:mainView];
        self.visualEffectView.alpha = 0.f;
        [self.view addSubview:self.visualEffectView];
        [self.view bringSubviewToFront:self.visualEffectView];

        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.visualEffectView setAlpha:1.f];
        } completion:^(BOOL finished) {

        }];

    }

    else if ([[notification name] isEqualToString:@"SendCancel"])
    {

        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.visualEffectView setAlpha:0.f];
        } completion:^(BOOL finished) {

            [self.visualEffectView removeFromSuperview];

        }];

    }

    else if ([[notification name] isEqualToString:@"TakePhoto"])
    {
    
        [self setUpCamera];

        self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    else if ([[notification name] isEqualToString:@"TakeVideo"])
    {
        [self setUpCamera];
        self.isVideo = YES;
        self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        self.imagePicker.videoMaximumDuration = 20; //seconds
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    else if ([[notification name] isEqualToString:@"PostNote"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Post"];
        [self.navigationController pushViewController: vc animated:YES];

    }
    else if ([[notification name] isEqualToString:@"PostLink"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Link"];
        [self.navigationController pushViewController: vc animated:YES];
        
    }
    
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

        [self pushSegueToDescriptionViewController];
        //  [self performSegueWithIdentifier:@"pushToDescription" sender:self];

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
            // [self performSegueWithIdentifier:@"pushToDescription" sender:self];
            [self pushSegueToDescriptionViewController];

        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self setUpCamera];

    self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:self.imagePicker animated:NO completion:nil];
        
    }];

}

@end
