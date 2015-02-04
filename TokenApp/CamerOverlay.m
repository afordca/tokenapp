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


        //add Camera Reverse button to the overlay view.

        UIButton *btnCamReverse = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCamReverse setTitle:@"Reverse" forState:UIControlStateNormal];

        //set the frame
        CGRect btnCamReverseFrame = CGRectMake(0, 300, 320, 40);
        btnCamReverse.frame = btnCamReverseFrame;

        [btnCamReverse addTarget:self
                          action:@selector(onClickCameraReverse)
                forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnCamReverse];
    }
    return self;
}

-(void)onClickCameraReverse
{
    NSLog(@"TEST : CAMERA REVERSE");
    
}


@end
