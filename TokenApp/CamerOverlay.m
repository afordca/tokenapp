//
//  CamerOverlay.m
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/3/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import "CamerOverlay.h"

@implementation CamerOverlay 

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];


        //Setting up Top Nav Bar
        UIView *viewTopNavBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        viewTopNavBar.backgroundColor = [UIColor blackColor];

        //add Cancel button to Top Nav Bar

        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
       // UIColor *colorTokenGreen = [UIColor colorWithRed:119.0 green:181.0 blue:81.0 alpha:.85];

        btnCancel.tintColor = [UIColor greenColor];

        //set the frame
        CGRect btnCancelFrame = CGRectMake(0, 0, 100, 40);
        btnCancel.frame = btnCancelFrame;
        [btnCancel addTarget:self
                   action:@selector(cameraCancel)
                   forControlEvents:UIControlEventTouchUpInside];
        
        [viewTopNavBar addSubview:btnCancel];

        UIButton *btnFlash = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[btnFlash setTitle:@"FLASH" forState:UIControlStateNormal];
        [btnFlash setBackgroundImage:[UIImage imageNamed:@"Flash"] forState:UIControlStateNormal];

        btnFlash.tintColor = [UIColor greenColor];

        //set the frame
        CGRect btnFlashFrame = CGRectMake(150, 10, 30, 30);
        btnFlash.frame = btnFlashFrame;
        [btnFlash addTarget:self
                      action:@selector(cameraFlash)
            forControlEvents:UIControlEventTouchUpInside];

        [viewTopNavBar addSubview:btnFlash];


        [self addSubview:viewTopNavBar];


        //add Camera Capture Photo to the overlay view.

        UIButton *btnCamCapturePhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       // [btnCamCapturePhoto setTitle:@"Take Photo" forState:UIControlStateNormal];


        [btnCamCapturePhoto setBackgroundImage :[UIImage imageNamed: @"Camera"] forState:UIControlStateNormal];


        //set the frame
        CGRect btnCamCapturePhotoFrame = CGRectMake(130, 480, 60, 60);
        btnCamCapturePhoto.frame = btnCamCapturePhotoFrame;
        btnCamCapturePhoto.imageView.contentMode = UIViewContentModeScaleAspectFit;


        [btnCamCapturePhoto addTarget:self
                          action:@selector(cameraCapture)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCamCapturePhoto];


        //add Camera Reverse button to the overlay view.

        UIButton *btnCamReverse = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[btnCamReverse setTitle:@"Reverse" forState:UIControlStateNormal];
        [btnCamReverse setBackgroundImage:[UIImage imageNamed:@"CameraFlip"] forState:UIControlStateNormal];
        //set the frame
        CGRect btnCamReverseFrame = CGRectMake(260, 495, 40, 40);
        btnCamReverse.frame = btnCamReverseFrame;

        [btnCamReverse addTarget:self
                          action:@selector(cameraReverse)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCamReverse];

        //add Camera Library button to the overlay view;

        UIButton *btnCamLibrary = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCamLibrary setTitle:@"Library" forState:UIControlStateNormal];
       // [btnCamLibrary setBackgroundImage:[UIImage imageNamed:@"Photo"] forState:UIControlStateNormal];
        //set the frame
        CGRect btnCamLibraryFrame = CGRectMake(0, 500, 100, 40);
        btnCamLibrary.frame = btnCamLibraryFrame;

        [btnCamLibrary addTarget:self
                          action:@selector(cameraLibrary)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCamLibrary];

    }
    return self;
}

-(void)cameraReverse
{
    NSLog(@"TEST : CAMERA REVERSE");
    [self.delegate onClickCameraReverse:@"Reverse"];
}

-(void)cameraLibrary
{
    NSLog(@"TEST: Camera Library");
    [self.delegate onClickCameraLibrary];
}

-(void)cameraCapture
{
    NSLog(@"TEST: Camera Capture");
    [self.delegate onClickCameraCapturePhoto];
}

-(void)cameraCancel
{
    NSLog(@"TEST: Camera Cancel");
    [self.delegate onClickCancel];
}

-(void)cameraFlash
{
    NSLog(@"TEST: Camera Flash");
    [self.delegate onClickFlashMode];
}

@end
