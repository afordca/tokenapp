//
//  BalanceViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/17/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "BalanceViewController.h"

#import "TKProfileViewController.h"
#import "TK_DescriptionViewController.h"
#import "TK_LinkViewController.h"
#import "TK_PostViewController.h"
#import "UIViewController+Camera.h"
#import "CamerOverlay.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568

@interface BalanceViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate>

@property UIVisualEffectView *visualEffectView;

@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;

@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;


@property BOOL isVideo;

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];

    
}



@end
