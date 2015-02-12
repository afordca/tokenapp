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

        //add Camera Capture Photo to the overlay view.
        UIButton *btnCamCapturePhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCamCapturePhoto setTitle:@"Take Photo" forState:UIControlStateNormal];
        //set the frame
        CGRect btnCamCapturePhotoFrame = CGRectMake(110, 500, 100, 40);
        btnCamCapturePhoto.frame = btnCamCapturePhotoFrame;

        [btnCamCapturePhoto addTarget:self
                          action:@selector(cameraCapture)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCamCapturePhoto];


        //add Camera Reverse button to the overlay view.
        UIButton *btnCamReverse = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCamReverse setTitle:@"Reverse" forState:UIControlStateNormal];
        //set the frame
        CGRect btnCamReverseFrame = CGRectMake(225, 500, 100, 40);
        btnCamReverse.frame = btnCamReverseFrame;

        [btnCamReverse addTarget:self
                          action:@selector(cameraReverse)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCamReverse];

        //add Camera Library button to the overlay view;
        UIButton *btnCamLibrary = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCamLibrary setTitle:@"Library" forState:UIControlStateNormal];
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


@end
