//
//  UIViewController+Camera.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/16/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568

@interface UIViewController (Camera)

@property User *currentUser;


@property UIVisualEffectView *visualEffectView;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property UIImagePickerController *imagePicker;
@property UIImagePickerController *imagePickerProfile;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;

@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;


@property BOOL isVideo;


-(void)setUpCamera;
-(void)pushSegueToDescriptionViewController;
-(void)addObserver;

@end
