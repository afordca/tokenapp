//
//  ExploreViewController.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/17/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "ExploreViewController.h"
#import "MFC_ProfileViewController.h"
#import "TK_DescriptionViewController.h"
#import "UIViewController+Camera.h"
#import "TK_LinkViewController.h"
#import "TK_PostViewController.h"
#import "CamerOverlay.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 568

@interface ExploreViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,CameraOverlayDelegate>

@property UIVisualEffectView *visualEffectView;

@property UIImagePickerController *imagePicker;
@property UIImage *imageCreatePhoto;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *stringVideoData;


@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;
@property (strong, nonatomic) IBOutlet UIButton *buttonPopular;

@property (strong, nonatomic) IBOutlet UIButton *buttonTrending;

@property (strong, nonatomic) IBOutlet UIButton *buttonExplore;

@property BOOL isVideo;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup Button Appearance
    CALayer *layerButtonPopular = self.buttonPopular.layer;
    layerButtonPopular.backgroundColor = [[UIColor clearColor] CGColor];
    layerButtonPopular.borderColor = [[UIColor whiteColor]CGColor];
    layerButtonPopular.borderWidth = 1.5f;

    CALayer *layerButtonTrending = self.buttonTrending.layer;
    layerButtonTrending.backgroundColor = [[UIColor clearColor] CGColor];
    layerButtonTrending.borderColor = [[UIColor whiteColor]CGColor];
    layerButtonTrending.borderWidth = 1.5f;

    CALayer *layerButtonExplore = self.buttonExplore.layer;
    layerButtonExplore.backgroundColor = [[UIColor clearColor] CGColor];
    layerButtonExplore.borderColor = [[UIColor whiteColor]CGColor];
    layerButtonExplore.borderWidth = 1.5f;

    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    [self addObserver];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"View Did Disappear");
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
}




@end
