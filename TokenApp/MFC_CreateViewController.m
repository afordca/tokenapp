//
//  MFC_CreateViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/3/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "MFC_CreateViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface MFC_CreateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;

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
    self.imagePicker = [UIImagePickerController new];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];


}

#pragma mark - Button Methods

- (IBAction)buttonPressCamera:(id)sender
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:NO completion:nil];

}

- (IBAction)buttonPressVideo:(id)sender
{
    self.imagePicker.sourceType = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:self.imagePicker animated:NO completion:nil];

}

- (IBAction)buttonPressWrite:(id)sender
{

}

- (IBAction)buttonPressLink:(id)sender
{

}


#pragma mark - UIImagePicker Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.imageCreatePhoto = [info objectForKey:UIImagePickerControllerOriginalImage];

        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(self.imageCreatePhoto, nil, nil, nil);
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeAudiovisualContent])
    {
        // grab our movie URL
        NSURL *chosenMovie = [info objectForKey:UIImagePickerControllerMediaURL];

        // save it to the Camera Roll
        UISaveVideoAtPathToSavedPhotosAlbum([chosenMovie path], nil, nil, nil);

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
