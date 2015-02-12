//
//  CamerOverlay.h
//  TokenApp
//
//  Created by Emmanuel Masangcay on 2/3/15.
//  Copyright (c) 2015 ABaselNotBasilProduction. All rights reserved.
//

#import <UIKit/UIKit.h>

// define the protocol for the delegate
@protocol CameraOverlayDelegate <NSObject>;

// define protocol functions that can be used in any class using this delegate
-(void)onClickCameraReverse:(NSString *)customClass;
-(void)onClickCameraLibrary;
-(void)onClickCameraCapturePhoto;

@end

@interface CamerOverlay : UIView <UITextFieldDelegate>

// define delegate property
@property id<CameraOverlayDelegate> delegate;


// define public functions
-(void)cameraReverse;
-(void)cameraLibrary;
-(void)cameraCapture;

@end
